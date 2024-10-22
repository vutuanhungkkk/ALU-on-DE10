This project involves designing a System-on-Chip (SOC) using a PS2 keyboard and an Altera DE10 Standard board. The project is divided into two main parts:

PART 1: FPGA IMPLEMENTATION
-Designed a decoder for the PS2 keyboard to process user inputs

-Implemented an Arithmetic Logic Unit (ALU) on the FPGA to perform corresponding operations based on user inputs

-The FPGA processes the keyboard inputs and performs the desired operations using the ALU
 
PART 2: FPGA - HPS COMMUNICATION AND LCD DISPLAY 
-Established communication between the FPGA and the Hard Processor System (HPS) on the Altera DE10 Standard board

-Used the HPS to control an LCD screen and display the keyboard inputs and results of the operations performed by the FPGA

-The LCD screen displays the user inputs and the corresponding results, providing a visual interface for the SOC

KEY COMPONENTS:
-PS2 Keyboard: used for user input
-Altera DE10 Standard Board: provides the FPGA and HPS for SOC implementation
-FPGA: implements the keyboard decoder and ALU
-HPS: controls the LCD screen and communicates with the FPGA
-LCD Screen: displays user inputs and results of operations

SYSTEM WORK FLOW:
-User inputs data using the PS2 keyboard
-The FPGA decodes the keyboard inputs and processes them using the ALU
-The FPGA sends the processed data to the HPS
-The HPS receives the data and controls the LCD screen to display the user inputs and results of operations
-The LCD screen displays the desired information, providing a visual interface for the SOC



Fig. 1 Design of the project
![image](https://github.com/user-attachments/assets/30a44792-60da-4ab4-a29a-32478da5443c)
Fig. 2 Reg Slave Interface
![image](https://github.com/user-attachments/assets/955f18c0-6f15-4909-83c8-04b57d4a83c5)
Fig. 3 Qsys system
![image](https://github.com/user-attachments/assets/67099ac0-f972-42dc-a6c7-40fa09e21df7)
![image](https://github.com/user-attachments/assets/492222bf-9cfc-4c17-8b2c-cb53c98c9122)





