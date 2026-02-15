# 4.5 GHz Microstrip Wilkinson Power Divider: From EM Simulation to Active System Integration

This repository covers the complete engineering lifecycle of a **Wilkinson Power Divider** operating at 4.5 GHz. The project bridges the gap between high-fidelity electromagnetic simulations in **CST Studio Suite**, system-level active integration, and professional hardware implementation in **Altium Designer**.

## 🚀 Project Overview
This design goes beyond ideal theoretical models by accounting for real-world manufacturing tolerances, parasitic elements, and **active system-level performance**. The workflow transitions from 3D EM optimization to a co-simulation environment where passive structures meet active semiconductor components.

## 🛠 Technical Specifications
* **Center Frequency:** 4.5 GHz
* **Substrate:** $h = 1.524$ mm, $\varepsilon_r \approx 3.53$ (Rogers RO4003C compatible)
* **Isolation Resistor:** $100\,\Omega$ (Optimized with realistic 0603 package parasitics)
* **Active Component:** Mini-Circuits **SAV-541+** pHEMT LNA (Integrated via .s2p Touchstone data)

## 📉 Design & Optimization Workflow

### 1. High-Fidelity EM Simulation (CST 3D)
* **Numerical Accuracy:** Applied a 30 cells-per-wavelength mesh density with "Electric ($E_t=0$)" Zmin boundary conditions for stable ground reference.
* **Optimization:** Performed parameter sweeps on `resistor_R` and `lengthram` to counteract parasitic-induced frequency shifts.

### 2. System-Level Active Integration (CST Schematic)
* **Active Co-Simulation:** Transitioned the 3D EM model into the **CST Design Studio (Schematic)** environment.
* **LNA Integration:** Integrated a Mini-Circuits **SAV-541+** Low Noise Amplifier at the output port using manufacturer-verified **Touchstone (.s2p)** data.
* **Gain Compensation:** Successfully demonstrated the compensation of the intrinsic $-3$ dB division loss, achieving a **net system gain of $\sim +4.5$ dB**.
* **Isolation Integrity:** Verified that port-to-port isolation remains robust at **$-26$ dB** even after active component integration.

### 3. Professional PCB Layout (Altium Designer)
* **Component Alignment:** Standardized component naming (**R1**) with vertical orientation to minimize signal interference.
* **RF Transitions:** Integrated **SMA Edge-Mount** pads optimized for $50\,\Omega$ microstrip-to-connector transitions.
* **Manufacturing:** Generated RS-274X Gerber files with high decimal precision to maintain microstrip geometry fidelity.

## 📊 Simulation Results (Active System)
* **$S_{11}$ (Return Loss):** Strong impedance match achieved at $\sim -15$ dB near the center frequency.
* **$S_{21}$ (System Gain):** Boosted to **> 0 dB** (Net gain of $\sim +4.5$ dB) due to LNA integration.
* **$S_{23}$ (Isolation):** Exceptional port-to-port isolation maintained at **$-26$ dB**.





