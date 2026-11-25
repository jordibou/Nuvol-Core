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

| ID        | Block | Feature                                                                                 | Stimulus            | Coverage bins       | Check           | Status |
|---------- |-------|------------------------------------------                                               |---------------------|---------------------|--------------------|--------|
| TP-DEC-01 | Immediate generator | Each format's immediate bits are placed in the correct `imm_o` positions  | Random              |                     | Scoreboard             |  |
| TP-DEC-02 | Immediate generator | For I, B, S and J, the sign in the instruction is the same as `imm_o[31]` | Random              | cp_sign             | Scoreboard     |  |
| TP-DEC-03 | Immediate generator | For I and S, the extended bits are equal to `instr_data_i[31]`            | Random              |                     | Scoreboard    |  |
| TP-DEC-04 | Immediate generator | For B, the extended bits are equal to `instr_data_i[31]`                  | Random              |                     | Scoreboard    |  |
| TP-DEC-05 | Immediate generator | For J, the extended bits are equal to `instr_data_i[31]`                  | Random              |                     | Scoreboard    |  |
| TP-DEC-06 | Immediate generator | For U, the `imm_o[11:0]` must be filled with zeroes                       | Random              |                     | Assertion    |  |
| TP-DEC-07 | Immediate generator | For B and J, the `imm_o[0]` must be zero                                  | Random              |                     | Assertion    |  |
| TP-DEC-08 | Immediate generator | `imm_o = '0` when an instruction does not have an immediate               | Random              |                     | Assertion    |  |

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