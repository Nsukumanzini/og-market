# Gijima Mfana — Development roadmap

## Product decisions

- Ermelo-first local marketplace with three services: shop, personal shopping, collect and deliver.
- Four separately launched Flutter apps: customer, merchant, courier, admin (web-first).
- Online-only payments in eventual production. Mock checkout never requests card data or makes network calls.
- Brand: emerald `#087F5B`, charcoal `#202A30`, white `#FFFFFF`.
- No backend in the current prototype; state is held in memory and fixtures are fictitious.

## Phase gates

| Phase | Deliverables | Exit criteria |
| --- | --- | --- |
| 1 — UI foundation | Rebrand customer application and mock catalogue, cart, checkout, requests, orders; independent role app starter dashboards | Customer can browse, add, simulate a payment and view an order offline; role apps have independent mock workflows; analyzer and tests pass locally |
| 2 — Detailed offline experiences | Merchant catalogue CRUD and order details; courier availability, pickup/dropoff and simulated tracking; admin approvals, fee settings, audit UI; customer authentication screens and request quotes | All screens have mock state, error/empty states and responsive layouts |
| 3 — Integration foundation (only after approval) | Backend environment separation, identity, roles, service zones, policies, test data | Cross-role access and ownership tests pass; no secrets in apps |
| 4 — Catalogue and orders | Merchant products, inventory, customer order lifecycle and quote/collection flows | Concurrent stock/order tests; price calculations are server-authoritative |
| 5 — Payments | Pick and integrate a supported online gateway with sandbox checkout, signed webhooks, idempotency, reconciliation, refunds and settlements | Retry and webhook tests, no raw card data; production payment credentials held server-side |
| 6 — Dispatch | Courier assignment, pickup and dropoff proof, escalation, status history | Valid state transitions and authorization, duplicate assignment prevention |
| 7 — Live tracking | Consent-based courier location, mapping, realtime notifications | Tracking only during authorized deliveries, limited access and expiry |
| 8 — Operations | Merchant onboarding, catalog moderation, courier verification, support, analytics, restricted-goods controls | Operational checklist and security review; local legal/payment provider requirements validated |
| 9 — Launch preparation | Device testing, accessibility, small-screen/low-bandwidth performance, store assets, support processes, security reviews | Complete real-world pilot and rollback plan |
| 10 — Ermelo pilot | Limited participating businesses, couriers and customers | Review delivery reliability, dispute handling, unit economics, reliability and consent before expansion |

## Implementation notes

- Start with single-merchant carts. Custom shopping requests require quotations; collection requests need pickup and destination details.
- Store monetary values in integer cents. Use payment gateway verification and idempotent server processing when backend integration is authorized.
- Access control and backend roles must be enforced server-side, regardless of which app is used.
- Validate relevant product eligibility, age verification rules, privacy obligations, delivery operations and payment provider restrictions before allowing restricted goods.
- No real orders, settlements, courier location or customer personal information should be used in this offline prototype.

## First verification

Run `flutter pub get`, `flutter analyze`, `flutter test` on the customer project. Then generate each role app's platform runners and test them separately. After the offline designs are agreed, implement integrations in an isolated development environment, not against the inactive legacy database.
