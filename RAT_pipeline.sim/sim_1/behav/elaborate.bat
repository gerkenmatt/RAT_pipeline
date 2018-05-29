@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xelab  -wto 4febdea06bc747668d9aacab6ef06a00 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot CPU_SIM_behav xil_defaultlib.CPU_SIM -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
