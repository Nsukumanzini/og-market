# Gijima Mfana

Offline Flutter prototype for a local marketplace, personal shopping and collection/delivery platform launching in Ermelo, South Africa.

**Phase 1 — mock data only.** No API credentials, backend, real payments, authentication, real businesses or live courier tracking. All records are illustrative and reset on restart.

## Repository layout

| Location | Application |
| --- | --- |
| Root (`lib/`) | Customer marketplace |
| `apps/merchant/` | Merchant order preparation prototype |
| `apps/courier/` | Courier delivery task prototype |
| `apps/admin/` | Admin verification prototype |
| `packages/gijima_ops/` | Shared offline operations dashboard UI |

The root retains the existing Flutter Android, iOS and web project shell where present. The role apps are independent Dart/Flutter packages. Their platform runners have not yet been generated; generate each separately before building its native or web targets. This keeps the apps independent rather than implementing role switching as a single product.

## Run the customer app

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

To run a role app, open its folder (for example `apps/merchant`) and run:

```sh
flutter create --platforms=android,ios,web --org com.gijimamfana .
flutter pub get
flutter run
```

Choose unique production bundle IDs, signing and store configuration before native release. Repeat per role; the admin app can target web alone if preferred.

## Customer prototype

- Browse sample stores, filter products and search.
- Add products from a single merchant to a cart; adjust quantities.
- Simulate an online checkout without collecting any card details or money.
- Submit personal shopping and existing-order collection requests offline.
- View session-local orders and requests; edit a demonstration delivery address.

The merchant, courier and admin apps have independent simulated task queues and state transitions; they are **not synchronized** with the customer app.

See [development roadmap](docs/ROADMAP.md) for next phases.
