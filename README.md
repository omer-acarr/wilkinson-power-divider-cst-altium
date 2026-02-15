# 4.5 GHz Microstrip Wilkinson Power Divider: From EM Simulation to PCB Fabrication

This repository covers the complete engineering lifecycle of a **Wilkinson Power Divider** operating at 4.5 GHz. The project bridges the gap between high-fidelity electromagnetic simulations in **CST Studio Suite** and professional hardware implementation in **Altium Designer**.

## 🚀 Project Overview
Unlike ideal theoretical models, this design accounts for real-world manufacturing tolerances and parasitic elements. The performance was optimized using "Parameter Sweep" and "Full-Wave EM Simulation" techniques to compensate for frequency shifts and loss, resulting in industry-standard **Gerber** files ready for production.

## 🛠 Technical Specifications
* **Center Frequency:** 4.5 GHz
* **Substrate:** $h = 1.524$ mm, $\varepsilon_r \approx 3.53$ (High-frequency compatible laminate)
* **Characteristic Impedance:** $50\,\Omega$ (Input/Output), $\sqrt{2}Z_0 \approx 70.7\,\Omega$ (Quarter-wave arms)
* **Isolation Resistor:** $100\,\Omega$ - $120\,\Omega$ (Modeled with realistic 0603 package parasitics)
* **PCB Dimensions:** $60\,\text{mm} \times 40\,\text{mm}$

## 📉 Design & Optimization Workflow

### 1. High-Fidelity EM Simulation (CST Studio Suite)
* **Parasitic Modeling:** Included $1.0\,\text{nH}$ series inductance and $0.05\,\text{pF}$ parallel capacitance to observe the impact of physical resistor packaging.
* **Numerical Accuracy:** Applied a 30 cells-per-wavelength mesh density with "Electric (Et=0)" Zmin boundary conditions for stable ground reference.
* **Optimization:** Performed parameter sweeps on `resistor_R` and `lengthram` to pull the resonance frequency back to the 4.5 GHz target after parasitic-induced upshifts.

### 2. Professional PCB Layout (Altium Designer)
* **Board Shape:** Optimized to a compact $60 \times 40\,\text{mm}$ area on the **Keep-Out Layer**.
* **Component Alignment:** Standardized component naming (**R1**) with vertical orientation to minimize signal interference and align with high-frequency design standards.
* **RF Connectors:** Integrated **SMA Edge-Mount** rectangular pads ($1.5\,\text{mm} \times 2.0\,\text{mm}$) optimized for $50\,\Omega$ microstrip transitions.

### 3. Manufacturing Preparation
* **Gerber Generation:** Produced RS-274X format files with 4:4 (0.0001 mm) decimal precision to maintain microstrip geometry fidelity.
* **Verification:** Validated copper geometry using **CAMtastic** to ensure perfect connectivity between SMA pads and microstrip traces.

## 📊 Simulation Results
* **$S_{11}$ (Return Loss):** Achieved an impedance match of approximately $-7.5\,\text{dB}$ at the design frequency.
* **$S_{21} / S_{31}$ (Insertion Loss):** Symmetric power division observed at $\sim -3.5\,\text{dB}$.
* **$S_{23}$ (Isolation):** Stable port-to-port isolation maintained at $\sim -14\,\text{dB}$ despite parasitic inclusions.



