# C_WIRE - Data Analysis Algorithm

This program combines **Shell scripting** and **C programming** to process and analyze data stored in a `.dat` file (`c-wire_v25.dat`). The results are output to `.csv` files, which provide insights based on user requests. Additionally, a graph file is generated to visually represent the analyzed data for better comprehension.

---

## Prerequisites

Before running this program, ensure you have the following tools installed on your machine:

- **GCC Compiler**: Required to compile the C program.
- **Gnuplot**: To generate graphs for visualizing the processed data.
- **Git**: To retrieve the latest version of the code.
- **Makefile** : Check that the tools for using a makefile are installed

## Installation

To install the necessary tools and ensure your system is up-to-date, run the following commands on a **Linux** system:

```bash
sudo apt update && sudo apt upgrade
 ```
---
## 🛠️ **Installing GCC Compiler**

**GCC (GNU Compiler Collection)** is a set of compilers for different programming languages, including C. This section explains how to install GCC on different operating systems and how to verify its installation.

---

# 🐧 **On Linux (Ubuntu/Debian)**

1. **Update your package list:**
   ```bash
   sudo apt update
    ```
2. **Install GCC:**
    ```bash
    sudo apt install build-essential
    ```
    The build-essential package includes GCC, along with other essential tools like make and libraries needed for compiling software.
 3. **Verify the insatllation**
 ```bash
    gcc --version
```
You should see the installed version of GCC.

#  💻 **On Windows**

1. **Install MinGW (Minimalist GNU for Windows):**
    -Download the MinGW installer from the official site: MinGW-w64(https://sourceforge.net/projects/mingw/)
    -Run the installer and select the version of GCC you want to install 
    -Makesure to  add thte bin directory to your system's PATH

2. **Verify the installation**

    -Open Commande Prompt and ru
    ```bash
    gcc --version
    ```
    -You should see the insatlled version of GCC
---
## 📊 **Installing Gnuplot**

**Gnuplot** is a software tool used to generate plots and graphs from data files. Follow the steps below to install Gnuplot depending on your operating system.

---

# 🐧 **On Linux (Ubuntu/Debian)**

1. Update your package list:
   ```bash
   sudo apt update
   ```
2. Install Gnuplot
   ```bash
   sudo apt install gnuplot
   ```
3. **Verify the installation:Run the folowing command:**
   ```bash 
   gnuplot --version
    ```
Exemple  output
```bash
gnuplot 5.4 patchlevel 1
```
---

#  💻**On windows**

1. **Downoald gnuplot:**
    -Go to the official Gnuplot page: Gnuplot Downloads(https://sourceforge.net/projects/gnuplot/)
    -Download the installer for Windows.
    
2. **Run the installer:**
    -Follow the installation wizard and install Gnuplot.
3. **Add Gnuplot to your system path (optional):**
    -During installation, ensure the option "Add Gnuplot to PATH" is selected.

4.  **Verify the installation:**
    -Open Command Prompt or PowerShell and type:
    ```bash
    gnuplot --version
    ```
    -You should see the installed version of Gnuplot.
**To launch the graph**

-Click on file at the top left, then on change directory and enter the main folder so that it finds our .gp file to launch the execution of the graph
-Then load ‘graphique.gp’ and a png with our graph will appear in the Graphs folder.

---
## 🔗✨ **How to recover our files from git**

1. # **Install Git**

    **On Linux**
    ```bash
    sudo apt update
    sudo apt install git
    ```
    **On Windows**
    -Download git via this link :https://git-scm.com/
2. # **Clone the git repository**

    **1. Find the git repository url**

        -If the repository is on a platform such as GitHub, GitLab or Bitbucket, retrieve the HTTPS or SSH URL. For example :
        -HTTPS : https://github.com/utilisateur/projet.git
        -SSH : git@github.com:utilisateur/projet.git

     **2.Exécutez la commande git clone**

        -Navigate to the directory where you want to clone the repository:

        ```bash
        cd /Path/to/folders
        ```
        -Clone the repository:
    
        ```bash
        git clone https://github.com/utilisateur/projet.git
        ```
        -Or, if you use SSH :
    
        ```bash 
        git clone git@github.com:utilisateur/projet.git
        ```
3. # **Access the cloned directory :**
        ```bash
        cd projet
        ```

4. # **Update the local repository**

    **1. Pulling changes from the remote repository**
    ```bash
    git pull
    ```
    **2. Check the condition of your local depot:**
    ```bash
    git status
    ```


---

## 📄 **How to install a makefile**

# 🐧 **On Linux (Ubuntu/Debian)**
    ```bash
    sudo apt update
    sudo apt install make
    ```

#  💻 **On Windows**
-Install make via MinGW or Cygwin, or use an environment such as WSL (Windows Subsystem for Linux).

---

## ▶️**How to Run the Program**

# **Step 1: Clone the Repository**

-Retrieve the latest version of the project using Git:

    ```bash

    git clone https://github.com/your-username/C_WIRE.git
    cd C_WIRE

    ```
# **Step 2: Execute the Program**

-Run the Shell script with the required parameters:
```bash
bash SHELL/c_wire.sh <Data_file> <station_type> <consumer_type> [ID]
```
# **Parameters:**

-<Data_file>: The name of the file containing the data:
    c-wire_v25.dat

-<station_type>: Type of station. Valid options:
    hvb - High Voltage Bus
    hva - High Voltage Area
    lv - Low Voltage

-<consumer_type>: Type of consumer. Valid options:
    comp - Company
    indiv - Individual
    all - All consumers

-[ID] (Optional): Specific Station ID (1 to 5). If omitted, all stations will be processe

---
# **Exemple usage**

-To process all stations of type hvb for individual consumers:
```bash
    bash SHELL/c_wire.sh c-wire_v25.dat hvb indiv
```
-To process station ID 3 of type hva for company consumers:
```bash
bash SHELL/c_wire.sh c-wire_v25.dat hva comp 3
```

---
## 💾 **Output**

- Data Analysis:
 Results are saved in a .csv file in the project root directory.

-Graphical Representation:
 Generated graphs are stored in the Graphs/ directory.

At the end of execution, the script also displays the total runtime in seconds.

---
## 🎵 **For Music**
If you want to listen to some nice music, just run c_wire.c with no arguments!

---

## 📂**Projet Structure**

The repository is organized as follows:
```bash
Cwire/
├── codeC/
│   ├── c_wire.c          # Fichier source C
│   ├── c_wire.exe
│   ├── fonctions.c
│   ├── fonctions.h
│   ├── MakeFile      # Exécutable compilé
│   └── musique.mp3       # Fichier audio associé
├── Input/
│   └── c-wire_v00.dat    # Fichier de données d'entrée
├── tests/ 
│   └── lv_all_0.csv              # Répertoire pour les tests (vide ou à remplir)
├── c_wire.sh             # Script principal pour exécuter le projet
├── graphique.gp          # Script Gnuplot pour les graphiques      
├── projet.pdf            # Documentation du projet
├── README.md             # Documentation générale du projet
```

---
## **Author**

# RISPOT Dorian,Métaireau Adam, Houidi Adem, MI-3

## **Cy-tech**


    
