# 4.5 GHz Microstrip Wilkinson Power Divider Design & Optimization

This repository contains the design, simulation, and optimization of a microstrip Wilkinson Power Divider operating at a center frequency of 4.5 GHz. The project was developed using **CST Studio Suite 2025** and focuses on realistic modeling by incorporating SMD component parasitic effects.

## 🚀 Project Overview
Unlike ideal theoretical models, this design accounts for real-world manufacturing tolerances and parasitic elements. The performance was optimized using "Parameter Sweep" and "Full-Wave EM Simulation" techniques to compensate for frequency shifts and loss.

## 🛠 Technical Specifications
* **Center Frequency:** 4.5 GHz
* **Substrate:** $h = 1.524$ mm, $\varepsilon_r \approx 3.53$ (High-frequency compatible laminate)
* **Characteristic Impedance:** $50 \, \Omega$ (Input/Output), $\sqrt{2}Z_0 \approx 70.7 \, \Omega$ (Quarter-wave arms)
* **Isolation Resistor:** $100 \, \Omega$ (Modeled with realistic parasitics)

## 📈 Design & Optimization Workflow

### 1. Realistic SMD Parasitic Modeling
To observe the impact of physical resistor packaging on RF performance, the following parasitics were included:
* **Series Inductance (L):** $1.0$ nH (Package lead inductance)
* **Parallel Capacitance (C):** $0.05$ pF
* **Landing Pattern:** A $1.3$ mm gap (mezera) was defined using "Pick Face" operations on the vertical copper edges for high-fidelity connection modeling.

### 2. Numerical Convergence & Meshing
To ensure simulation accuracy and satisfy the "three mesh steps" rule for lumped elements:
* **Cells per wavelength:** Increased to 30 for high-resolution field analysis.
* **Boundary Conditions:** The Zmin boundary was set to "Electric (Et=0)" to stabilize the ground reference and resolve numerical errors.
* **Complexity:** Final convergence was achieved with approximately 32,000 mesh cells.

### 3. Parameter Sweep & Tuning
The added parasitic inductance caused a frequency upshift to ~4.65 GHz. Optimization was performed via:
* **Resistance ($resistor\_R$):** Swept between 80-120 $\Omega$ to find the optimal isolation depth.
* **Arm Length ($lengthram$):** Physically tuned to pull the resonance frequency back to the 4.5 GHz target.

## 📊 Simulation Results
* **$S_{11}$ (Return Loss):** Achieved an impedance match of approximately $-7.5$ dB at the design frequency.
* **$S_{21} / S_{31}$ (Insertion Loss):** Perfect power division symmetry observed at $\sim -3.5$ dB.
* **$S_{23}$ (Isolation):** Stable port-to-port isolation maintained at $\sim -14$ dB despite parasitic effects.

## 🔜 Future Work
* Exporting the geometry to **Altium Designer** for final PCB layout and manufacturing preparation.
* Integration of the Wilkinson Divider with a **Vivaldi Antenna** array to analyze total system gain and radiation patterns.

