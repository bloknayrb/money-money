# Data Sync Strategy — Task Tracking

## Immediate (No Code — Bryan's Action Items)

- [ ] Sign up for SimpleFIN Bridge ($15/year) at beta-bridge.simplefin.org
- [ ] Connect Chase (2 logins) and Synchrony/Amazon Store Card through SimpleFIN dashboard
- [ ] Generate SimpleFIN setup token and paste into Money Money
- [ ] Sign up for SnapTrade (free tier) at snaptrade.com, explore API docs
- [ ] Generate read-only Coinbase CDP API key at portal.cdp.coinbase.com
- [ ] Create manual Money Money accounts for Fundrise, Moomoo, Target Circle Card

## Future Integration: SnapTrade (Phase 3)

Brokerage-focused aggregator. Free tier covers 5 connections: Fidelity NetBenefits, Robinhood, Schwab Workplace, E*Trade, Betterment.

- [ ] Create `SnapTradeClient` (Dio-based, mirrors `SimplefinClient`)
- [ ] Add `'snaptrade'` provider value to `BankConnections` table
- [ ] Create `SnapTradeSyncService` (mirrors `SimplefinSyncService`)
- [ ] Add secure storage keys for SnapTrade API credentials
- [ ] Build UI setup flow (similar to SimpleFIN wizard)
- [ ] Sync positions, balances, and holdings

## Future Integration: Coinbase CDP API (Phase 3)

Direct REST API for crypto portfolio. Free with API key auth.

- [ ] Create `CoinbaseClient` (Dio-based, mirrors `SimplefinClient`)
- [ ] Add `'coinbase'` provider value to `BankConnections` table
- [ ] Create `CoinbaseSyncService`
- [ ] Add secure storage keys for Coinbase API credentials
- [ ] Build UI setup flow
- [ ] Sync wallets, balances, and transaction history

## Manual Accounts (Ongoing)

| Institution | Why Manual | Update Frequency |
|---|---|---|
| Fundrise | Partner-only API, no aggregator support | Monthly |
| Moomoo | Custom TCP/Protobuf protocol, no REST API | Weekly |
| Target Circle Card | No API, no OFX, no aggregator | Monthly |

## Coverage Matrix

| Institution | Source | Confidence | Status |
|---|---|---|---|
| Chase (2 logins) | SimpleFIN | High | Pending setup |
| Synchrony / Amazon Store Card | SimpleFIN | Medium | Pending setup |
| E*Trade | SnapTrade (or SimpleFIN) | High | Future |
| Schwab Workplace | SnapTrade | High | Future |
| Fidelity NetBenefits | SnapTrade | High | Future |
| Robinhood | SnapTrade | High | Future |
| Betterment | SnapTrade | High | Future |
| Coinbase | Direct API | High | Future |
| Target Circle Card | Manual | N/A | Create account |
| Fundrise | Manual | N/A | Create account |
| Moomoo | Manual | N/A | Create account |
