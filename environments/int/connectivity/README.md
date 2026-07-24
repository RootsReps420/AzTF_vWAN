# environments/int/connectivity

Connectivity subscription root for **int** (DT / dev test).

Deploys:
- Baseline Azure Firewall Policy (stub — full rules deferred to Azure Policy workstream)
- Hub01 secured (AZFW + routing intent + ER gateway)
- Hub02 unsecured (VPN gateway scaffold — peer/site deferred)

Requires `virtual_wan_id` from `environments/_global`.

## Offline check

```bash
terraform init -backend=false
terraform validate
```

Do not `plan`/`apply` until subscription GUIDs + auth are ready.
