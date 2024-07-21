# Bootloader 

This was a Bootloader made for some assembly practise. It uses a FAT12 disk format.

## Run Locally

#### Requirements
1. [Watcomm-Compiler](https://github.com/open-watcom/open-watcom-v2) ,This project is in 16bits so it uses this 16 bit compiler to compile all the files, The linker used is also from this.
2. **Qemu-system-i386** , To run the project it is an open source machine emulator and virtualizer 
you can install it using the command
```bash
sudo apt update
sudo apt-get install qemu-system-i386 -y
```
3. **mkfs.fat** and **mcopy** for formatting and making the FAT12 Disk, these tools can be installed using the command
```bash
sudo apt update
sudo apt install dosfstools mtools
```
4.**Nasm** , x86 assembler for the asm files , can be installed using the command 
```bash
sudo apt update
sudo apt install nasm
```

Firstly install the requirements above

Then clone the project 

```bash
git clone https://github.com/Kunal-Singh-Dadhwal/x86_Assembly
```

Then make the file 

```bash
make
```

## Errors
The system is currently having the error `` Failed to read disk ``
, You can find the message in [boot.asm](./src/bootloader/boot.asm) 

## Contributing 
To contribute firstly install the [Requirements](#requirements) for the project 

Then clone the project
```bash
git clone https://github.com/Kunal-Singh-Dadhwal/x86_Assembly
```

Then make your own branch 

```bash
git checkout -b "Any_Name_You_Like"
```
Then make the changes to resolve the error and then push the changes

```bash
git add . && git push origin Name_of_your_branch
```

Test the project using the command 
```bash 
make
```

Make a pull request to make the contribution
