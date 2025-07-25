
# 🚑 Smart Interactive CPR Training App – Pulse Guard

> **TEAM ID:** Team(CLB)_3_14  
> **GitHub Repo:** https://github.com/goudaritesh/Pulse_Guard  
> **Project Domain:** MedTech | CPR Education  
> **Tagline:** Learn. Practice. Save Lives. Anywhere, Anytime.

---

## 📌 Project Overview
Pulse Guard is a smartphone-based CPR training tool, designed to help users practice proper chest compression rhythm using everyday objects like pillows or CPR dummies. The app uses the phone’s built-in sensors to detect compression movements and provides real-time feedback, voice guidance, and gamified scoring to simulate a CPR session. Pulse Guard is meant to assist users in building CPR confidence and rhythm through practice on safe, non-human surfaces.

By turning an ordinary phone into a hands-on CPR rhythm trainer, Pulse Guard offers an accessible, offline solution for individuals, schools, and communities to learn life-saving skills — safely, affordably, and interactively.

---

## 🧠 Problem Solved

- Lack of access to CPR mannequins and live training
- Poor retention and confidence in CPR technique
- Minimal awareness in underserved regions
- No portable way to practice realistic CPR rhythm

---

## 🎯 Key Features

- 📱 **Sensor-Based Training:** Uses phone's accelerometer to detect chest compressions
- 🧠 **User Mode Selection:** Train for Adults (>45 / ≤45), Children, Male/Female patients
- 🗣 **Voice Prompts:** Real-time text-to-speech coaching
- 🟢 **Visual Feedback:** Color-coded rhythm validation (green = correct, red = incorrect)
- 🏅 **Gamification:** Scoreboard after each session with retry option
- 🌐 **Offline Usability:** Practice CPR anywhere without needing internet
- 📊 **Session Summary:** Compression count, feedback, and improvement tips

---

## 👥 Team Members

| Name                 | Roll No.         | Role                          |
|----------------------|------------------|-------------------------------|
| Anurag Panigrahi     | 23CSEAIML005      | Sensor Logic & App Logic      |
| Ritesh Kumar Gouda   | 23CSEAIML010      | Flutter Developer & Frontend  |
| Vivek Patnaik        | 23CSEAIML031      | UI/UX Design & TTS Flow       |
| Harmesh Behera       | 23CSEAIML040      | Firebase Integration & Hosting|

---

## 🧪 Tech Stack

- **Frontend:** Flutter (Dart)
- **Sensors:** `sensors_plus` (Accelerometer  and gyrometer)
- **Gamification & Logic:** Custom Dart-based scoring system
- **Version Control:** Git + GitHub

---

## 🔧 Setup Instructions

> 💡 Prerequisites: Install [Flutter SDK](https://docs.flutter.dev/get-started/install)

1. **Clone the Repository**
bash
git clone https://github.com/goudaritesh/Pulse_Guard.git
cd Pulse_Guard
`

2. **Install Flutter Dependencies**

bash
flutter pub get


3. **Run the App**

bash
flutter run


> ⚠ Use a physical Android device for best results (sensor input won't work well on emulators).

4. **(Optional) Firebase Setup**

* Add your `google-services.json` file to `android/app/`
* Enable Firestore in Firebase Console

---

## 📲 How to Use the App

> This section is based on our recorded demo & pitch script.

1. **Launch the App**
   Tap to open the app on your smartphone.

2. **Select Patient Type**
   Choose whether you are practicing CPR for:

   * Male / Female
   * Adult (>45 years / ≤45 years)
   * Child

3. **Place Phone on Surface**
   Put your phone flat on a pillow or cushion (acts like a dummy).

4. **Start CPR Simulation**
   Press rhythmically on the phone. The app reads the **Z-axis acceleration** to measure compression rate.

5. **Get Real-Time Feedback**

   * Green screen = Correct rhythm (100–120 compressions/min)
   * Red screen = Too fast or too slow
   * Voice prompts guide you as you train

6. **Review Score After Session**

   * Your score is calculated
   * Feedback is shown: “Great rhythm!” or “Try slowing down.”

7. **Retry or Exit**
   Train again or exit the session after reviewing your results.

---

## 🎞 Demo Video

📺 [Watch Our Demo Video]([https://youtu.be/NjAeaCOlbGk?feature=shared])


---

## 📎 Final Presentation

📄 [Download Presentation Slide Deck (PDF)](https://github.com/goudaritesh/Pulse_Guard/raw/main/Team%28CLB%29_3_14%20presentation.pdf)

---



## 🔮 Future Scope

* 🧠 Integrate ML models for accurate depth classification
* 🌍 Add support for regional languages (Hindi, Odia, etc.)
* 🎓 Introduce certification mode with progress tracking
* 📱 Add AED training modules and emergency guides

---



## 📫 Contact Us

📧 Email: [goudariteshkumar1@gmail.com](goudariteshkumar1@gmail.com)
🔗 GitHub: [https://github.com/goudaritesh/Pulse\_Guard](https://github.com/goudaritesh/Pulse_Guard)

---

> “CPR should be universal knowledge — and with Pulse Guard, it finally can be.”


