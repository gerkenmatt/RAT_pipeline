@echo off
REM ****************************************************************************
REM Vivado (TM) v2017.4 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
<<<<<<< HEAD
REM Generated by Vivado on Thu Jun 07 15:38:04 -0700 2018
=======
REM Generated by Vivado on Sat Jun 02 13:12:23 -0700 2018
>>>>>>> parent of 40cbf29... just added null when branches are taken
REM SW Build 2086221 on Fri Dec 15 20:55:39 MST 2017
REM
REM Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
call xsim CPU_SIM_behav -key {Behavioral:sim_1:Functional:CPU_SIM} -tclbatch CPU_SIM.tcl -view C:/Users/gerke/workspace/RAT_pipeline/testing_s1_and_haz.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
