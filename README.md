README.md content**:

`markdown
# 🚑 Smart Interactive CPR Training App

> **TEAM_ID:** Team(CLB)_3_14  
> **Project Type:** MedTech Hackathon – CPR Education  
> **Tagline:** Learn. Practice. Save Lives. Anywhere, Anytime.

---

## 📌 Project Overview

Sudden cardiac arrest is a leading cause of death globally, yet most people lack the training and confidence to perform CPR during emergencies. Traditional CPR training methods require in-person sessions, expensive mannequins, and trained instructors — resources that are often unavailable or inaccessible to the general public.

Our solution transforms any smartphone into a **portable CPR trainer** by leveraging built-in motion sensors, voice guidance, and gamification. It empowers users to learn and practice proper CPR compression rhythm **without any external equipment**.

---

## 🎯 Key Features

- 📱 **Sensor-Based Training:** Detect CPR compression rate using accelerometer data.
- 🗣 **Voice-Guided Instructions:** Text-to-speech guidance for real-time correction.
- 🟢 **Visual Feedback:** Color indicators for CPR rhythm (perfect / too fast / too slow).
- 🧒 **User Type Selector:** Choose between Adult > 45, Adult ≤ 45, and Child; Male or Female.
- 🏅 **Gamification:** Score-based feedback after each session.
- 🌐 **Offline Capability:** Works without internet — ideal for rural or remote users.

---

## 👥 Team Members

| Name | Roll No. | Role |
|------|----------|------|
| Anurag Panigrahi | 23CSEAIML005 | Sensor & Feedback Logic |
| Ritesh Kumar Gouda | 23CSEAIML010 | Backend & Integration |
| Vivek Patnaik | 23CSEAIML031 | UI/UX Designer & Content |
| Harmesh Behera | 23CSEAIML040 | Flutter Frontend Developer |

---

## 🧪 Tech Stack

- **Frontend:** Flutter (Dart)
- **Sensor Access:** `sensors_plus`
- **Text-to-Speech (TTS):** `flutter_tts`
- **Backend (Optional):** Firebase (for storing scores, analytics)
- **Version Control:** Git + GitHub

---

## 🔧 Setup Instructions

> 💡 Make sure you have Flutter installed: https://flutter.dev/docs/get-started/install

1. **Clone the Repository**
   bash
   git clone https://github.com/your-username/CPR_Trainer_TeamCLB_3_14.git
   cd CPR_Trainer_TeamCLB_3_14
`

2. **Install Dependencies**

   bash
   flutter pub get
   

3. **Run the App**

   bash
   flutter run
   

4. **(Optional) Set Up Firebase**

   * Add your `google-services.json` file to `android/app/`
   * Follow Firebase integration steps in Flutter documentation

---

## 🎞 Demo Video

📺 [Watch Our 3-Minute Demo Video](https://drive.google.com/file/d/your-video-link-here/view?usp=sharing)
*(Make sure link access is set to “Anyone with the link can view”)*

---

## 📎 Project Presentation

📄 [Download the Presentation PPT](https://github.com/goudaritesh/Pulse_Guard/blob/main/Team(CLB)_3_14%20presentation.pdf)
Includes pitch, solution flow, stakeholder analysis, and sprint breakdown.

---

## 📂 Repository Structure


.
├── lib/
│   ├── main.dart
│   ├── compression_detector.dart
│   └── screens/
│       └── home.dart
├── assets/
│   ├── sounds/
│   └── images/
├── CPR_Pitch_Team(CLB)_3_14.pptx
├── README.md
└── pubspec.yaml


---

## 🔮 Future Scope

* 🧠 Add machine learning models to detect compression quality (depth + rhythm)
* 🌍 Multilingual training (Hindi, Odia, etc.)
* 🩺 Integration with first-aid certification frameworks
* 🧘 Post-CPR health tips and automated AED education modules

---

## 📫 Contact

For follow-up or collaborations, feel free to reach out:

📧 [cprteam314@gmail.com](mailto:cprteam314@gmail.com)
🔗 [GitHub Repo](https://github.com/your-username/CPR_Trainer_TeamCLB_3_14)

---

> CPR should be universal knowledge — and with our app, it finally can be.
