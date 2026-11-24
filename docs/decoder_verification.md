# Decoder – Verification Plan & Sign-off

| Field     | Value                                   |
|-----------|-----------------------------------------|
| Block     | `nuvol_deccoder` (rtl/nuvol_decoder.sv)  |
| Version   | v1.0                                    |
| Date      | 2026-11-19                              |
| Author    | Jordi Bou Garcia                        |
| Status    | **Signed off**                          |

## 1. Design summary

## 2. Verification environment
- Methodology: SystemVerilog UVM 1.2 + SVA
- Simulator: Vivado 2026.1 xsim (Windows)
- Components: seq_item, sequences (fill, pattern, random), sequencer, driver, monitor, agent,
  scoreboard (reference model), coverage subscriber, env, tests
- Assertions: `decoder_sva.sv`, bound into the DUT with `bind`
- Location: `tb/decoder/`

## 3. Test plan

| ID        | Feature                                  | Stimulus            | Coverage            | Assertion          | Status |
|---------- |------------------------------------------|---------------------|---------------------|--------------------|--------|
| TP-DEC-01 |     |     |       |     |  |
| TP-DEC-02 |    |     |       |     |  |
| TP-DEC-03 |    |     |       |     |  |
| TP-DEC-04 |    |     |       |     |  |
| TP-DEC-05 |    |     |       |     |  |
| TP-DEC-06 |    |     |       |     |  |
| TP-DEC-07 |    |     |       |     |  |

## 4. Tests
| Test                | Description                                          |
|---------------------|------------------------------------------------------|
| regfile_full_test   | fill → pattern → 2000 random transactions            |

## 5. Results
| Metric                    | Result              |
|---------------------------|---------------------|
| Functional coverage       | 100.00 %            |
| Scoreboard checks         | 4396, 0 errors      |
| SVA failures              | 0                   |
| Regression                | 10/10 seeds PASS (`regress.ps1`) |

## 6. Bug injection (checker validation)
| Injected bug                         | Caught by                   | Result      |
|--------------------------------------|-----------------------------|-------------|
| Wrong write address (`waddr ^ 1`)    | a_wr, a_stable, scoreboard  | TEST FAILED |

## 7. How to run
    cd tb/decoder
    .\regress.ps1             # 10 seeds
    .\regress.ps1 -Seeds 50

## 8. Known limitations
- Code coverage HTML report not available (xcrg blocked by Vivado BASIC license);
  functional coverage is merged inside regfile_full_test instead.

## 9. Change history
| Version | Date       | Change            |
|---------|------------|-------------------|