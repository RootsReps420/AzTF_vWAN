# Superseded environment roots

`environments/uksouth/{dev,prod}` were the greenfield single-root demos.

They are **superseded** by the migration layout:

```
environments/_global/                 # shared Virtual WAN
environments/int/connectivity/        # DT — first live target
environments/prod/connectivity/       # production (legacy prd)
environments/{int,prod}/{mgmt,avd,labs}/   # Phase D+ (not yet created)
environments/{idv,ici,itt}/...             # keep split; scaffold later
```

Do not deploy from `uksouth/` for the Azure 1.0 cutover. Prefer `int` / `prod` per-scope roots.
These folders may be removed once `int`/`prod` stacks cover the greenfield module composition.
