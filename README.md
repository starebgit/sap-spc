# SapSpcWinForms

## Nightly report (Task Scheduler)

`SapSpcWinForms.exe /porocilo` emails every measurement from yesterday that is outside the limits.
Recipients: `prejemniki.txt` next to the exe, one address per line (`#` = comment).

- **Server:** `172.20.1.14` (RDP: `Server.rdp` on Beno's desktop)
- **Task:** `SapSpc nocno porocilo`, daily 00:00, runs as SYSTEM
- **Exe:** `\\server-ad2\eta_data\06_PTC2\35_Strojna_meritve\SapSpc Nova\SapSpcWinForms.exe`

### Check it

1. RDP to `172.20.1.14`.
2. Start → `cmd` → right-click → **Run as administrator**.
3. Run:
   ```
   schtasks /Query /TN "SapSpc nocno porocilo" /V /FO LIST | findstr /I "Status Result Next"
   ```
   `Last Result: 0` = OK.
4. Log: `C:\Windows\System32\config\systemprofile\AppData\Local\SapSpcWinForms\diagnostic.log`

### Send it now (test, only to TestniPrejemniki)

```
"\\server-ad2\eta_data\06_PTC2\35_Strojna_meritve\SapSpc Nova\SapSpcWinForms.exe" /porocilo /test
```
Another day: add the date, e.g. `/porocilo 2026-10-05 /test`.

### Create it again (if it's gone)

1. Steps 1–2 above.
2. Run:
   ```
   schtasks /Create /TN "SapSpc nocno porocilo" /TR "\"\\server-ad2\eta_data\06_PTC2\35_Strojna_meritve\SapSpc Nova\SapSpcWinForms.exe\" /porocilo" /SC DAILY /ST 00:00 /RU SYSTEM /F
   ```
3. Check as above.
