/// A scripted fake backend for the three stress-test pages.
///
/// It exists to make every state reachable on demand: the pages are the thing
/// under test, so the data layer has to be able to fail on request, fail in one
/// region while another succeeds, and throw a raw backend string that must
/// never reach user copy.
library;

import 'dart:async';

import 'package:elattar_design_system/elattar_design_system.dart'
    show MotionDurations;

import 'stress_error.dart';

/// What a region should do on its next request.
enum Outcome {
  succeed,
  empty,
  offline,
  server,
  timeout,
  forbidden,
  declined,
  conflict,
  cancelled,
}

enum InvoiceStatus { paid, due, pastDue, draft }

class Invoice {
  const Invoice({
    required this.number,
    required this.issued,
    required this.amount,
    required this.status,
  });

  final String number;
  final String issued;

  /// Formatted at the boundary. A page never formats currency by hand.
  final String amount;
  final InvoiceStatus status;
}

class BillingSummary {
  const BillingSummary({
    required this.amountDue,
    required this.nextCharge,
    required this.paymentMethod,
  });

  final String amountDue;
  final String nextCharge;
  final String paymentMethod;
}

enum MemberRole { owner, admin, editor, viewer }

enum MemberStatus { active, invited, suspended }

class Member {
  const Member({
    required this.id,
    required this.name,
    required this.email,
    required this.initials,
    required this.role,
    required this.status,
    required this.lastActive,
  });

  final String id;
  final String name;
  final String email;
  final String initials;
  final MemberRole role;
  final MemberStatus status;
  final String lastActive;
}

/// The scripted backend. One instance per page.
class StressRepository {
  Outcome summaryOutcome = Outcome.succeed;
  Outcome listOutcome = Outcome.succeed;
  Outcome payOutcome = Outcome.succeed;
  Outcome membersOutcome = Outcome.succeed;
  Outcome inviteOutcome = Outcome.succeed;

  /// Every request pauses for one motion beat so loading states are real
  /// rather than theoretical.
  Future<void> _beat() => Future<void>.delayed(MotionDurations.slow);

  Future<BillingSummary> summary() async {
    await _beat();
    _throwIfFailing(summaryOutcome, 'summary');
    return const BillingSummary(
      amountDue: r'$1,248.00',
      nextCharge: '12 September 2026',
      paymentMethod: 'Visa ending 4242',
    );
  }

  Future<List<Invoice>> invoices({required bool filtered}) async {
    await _beat();
    _throwIfFailing(listOutcome, 'invoices');
    if (listOutcome == Outcome.empty || filtered) return const <Invoice>[];
    return const <Invoice>[
      Invoice(
        number: 'INV-1042',
        issued: '1 August 2026',
        amount: r'$420.00',
        status: InvoiceStatus.pastDue,
      ),
      Invoice(
        number: 'INV-1041',
        issued: '1 July 2026',
        amount: r'$420.00',
        status: InvoiceStatus.paid,
      ),
      Invoice(
        number: 'INV-1040',
        issued: '1 June 2026',
        amount: r'$408.00',
        status: InvoiceStatus.paid,
      ),
      Invoice(
        number: 'INV-1039',
        issued: '1 May 2026',
        amount: r'$408.00',
        status: InvoiceStatus.due,
      ),
    ];
  }

  /// The declined-payment path. The backend string is deliberately hostile.
  Future<void> pay(String invoiceNumber) async {
    await _beat();
    if (payOutcome == Outcome.declined) {
      throw const TransportFailure(
        ErrorKind.conflict,
        diagnostics:
            'POST /v1/charges 402 card_declined '
            '{"decline_code":"insufficient_funds","charge":"ch_3PqL"}',
        correlationId: 'ch_3PqL2eZ',
        titleOverride: 'Your card was declined',
        bodyOverride:
            'Your bank did not approve this payment. Nothing was charged.',
        nextStepOverride: 'Use a different card',
      );
    }
    _throwIfFailing(payOutcome, 'pay');
  }

  Future<List<Member>> members({required bool filtered}) async {
    await _beat();
    _throwIfFailing(membersOutcome, 'members');
    if (membersOutcome == Outcome.empty || filtered) return const <Member>[];
    return const <Member>[
      Member(
        id: 'm1',
        name: 'Amina Rahmouni',
        email: 'amina.rahmouni@northwind-logistics-international.example.com',
        initials: 'AR',
        role: MemberRole.owner,
        status: MemberStatus.active,
        lastActive: 'Today',
      ),
      Member(
        id: 'm2',
        name: 'Tobias Lindqvist',
        email: 'tobias@northwind.example',
        initials: 'TL',
        role: MemberRole.admin,
        status: MemberStatus.active,
        lastActive: 'Yesterday',
      ),
      Member(
        id: 'm3',
        name: 'Priya Raman',
        email: 'priya@northwind.example',
        initials: 'PR',
        role: MemberRole.editor,
        status: MemberStatus.invited,
        lastActive: 'Never',
      ),
      Member(
        id: 'm4',
        name: 'Ken Watanabe',
        email: 'ken@northwind.example',
        initials: 'KW',
        role: MemberRole.viewer,
        status: MemberStatus.suspended,
        lastActive: '3 weeks ago',
      ),
    ];
  }

  Future<void> invite(String email) async {
    await _beat();
    if (inviteOutcome == Outcome.succeed && !email.contains('@')) {
      throw const TransportFailure(
        ErrorKind.validation,
        diagnostics: 'POST /v1/invites 422 {"email":["is not an email"]}',
        fieldErrors: <String, String>{
          'email': 'Enter a work email address, like name@company.com',
        },
      );
    }
    _throwIfFailing(inviteOutcome, 'invite');
  }

  Future<void> removeMember(String id) async {
    await _beat();
    _throwIfFailing(membersOutcome, 'remove');
  }

  void _throwIfFailing(Outcome outcome, String route) {
    switch (outcome) {
      case Outcome.succeed:
      case Outcome.empty:
      case Outcome.declined:
        return;
      case Outcome.offline:
        throw TransportFailure(
          ErrorKind.offline,
          diagnostics: 'SocketException: failed host lookup on /v1/$route',
        );
      case Outcome.server:
        throw TransportFailure(
          ErrorKind.server,
          diagnostics:
              'GET /v1/$route 500 '
              'NullPointerException at BillingResolver.kt:214',
          correlationId: 'req_8f21ac',
        );
      case Outcome.timeout:
        throw TransportFailure(
          ErrorKind.timeout,
          diagnostics: 'TimeoutException after 30s on /v1/$route',
        );
      case Outcome.forbidden:
        throw TransportFailure(
          ErrorKind.forbidden,
          diagnostics: 'GET /v1/$route 403 {"scope":"billing:read"}',
        );
      case Outcome.conflict:
        throw TransportFailure(
          ErrorKind.conflict,
          diagnostics: 'PATCH /v1/$route 409 {"version":"stale"}',
        );
      case Outcome.cancelled:
        throw TransportFailure(
          ErrorKind.cancelled,
          diagnostics: 'request aborted by caller',
        );
    }
  }
}
