# regress.ps1 - multi-seed regression for the register file
param(
    [string]$Test  = "regfile_full_test",
    [int]   $Seeds = 100
)


$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force logs | Out-Null



# 1. Compile and elaborate once
Write-Host "Compiling..."
cmd /c "xvlog -sv -L uvm -f tb.f > logs\compile.log 2>&1"
if ($LASTEXITCODE -ne 0) { Write-Host "xvlog FAILED (see logs\compile.log)" -ForegroundColor Red; exit 1 }
cmd /c "xelab regfile_tb -L uvm -debug typical -s regfile_sim > logs\elab.log 2>&1"
if ($LASTEXITCODE -ne 0) { Write-Host "xelab FAILED (see logs\elab.log)" -ForegroundColor Red; exit 1 }


# 2. Run every seed and judge its log
$failed = 0
foreach ($seed in 1..$Seeds) {
    $log = "logs\seed_$seed.log"
    cmd /c "xsim regfile_sim -R -sv_seed $seed -testplusarg `"UVM_TESTNAME=$Test`" > $log 2>&1"
    $passed = (Select-String -Path $log -Pattern "TEST PASSED" -Quiet) -and
              (Select-String -Path $log -Pattern "UVM_ERROR :\s+0" -Quiet) -and
              (Select-String -Path $log -Pattern "UVM_FATAL :\s+0" -Quiet)
    if ($passed) { Write-Host "seed $seed : PASS" -ForegroundColor Green }
    else         { Write-Host "seed $seed : FAIL ($log)" -ForegroundColor Red; $failed++ }
}

# 3. Summary
Write-Host "-----------------------------"
if ($failed -eq 0) { Write-Host "REGRESSION PASSED: $Seeds/$Seeds seeds" -ForegroundColor Green; exit 0 }
else               { Write-Host "REGRESSION FAILED: $failed/$Seeds seeds failed" -ForegroundColor Red; exit 1 }