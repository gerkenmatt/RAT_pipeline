----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2018 04:00:27 PM
-- Design Name: 
-- Module Name: stage1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity stage1 is
    Port ( CLK     : in  STD_LOGIC;
       S1_EN       : in STD_LOGIC;
       PC_INC      : in  STD_LOGIC;
       PC_LD       : in  STD_LOGIC;
       RST         : in  STD_LOGIC;
       PC_MUX_SEL  : in  STD_LOGIC_VECTOR (1 downto 0);
       FROM_IMMED  : in  STD_LOGIC_VECTOR (9 downto 0);
       FROM_STACK  : in  STD_LOGIC_VECTOR (9 downto 0);
       PC_COUNT    : out STD_LOGIC_VECTOR (9 downto 0);
       INSTRUCTION : out std_logic_vector(17 downto 0));
end stage1;

architecture Behavioral of stage1 is
signal PC_COUNT_sig : STD_LOGIC_VECTOR(9 downto 0);

component PC is
    Port ( CLK     : in  STD_LOGIC;
       S1_EN       : in STD_LOGIC;
--       PC_INC      : in  STD_LOGIC;
       PC_LD       : in  STD_LOGIC;
       RST         : in  STD_LOGIC;
       PC_MUX_SEL  : in  STD_LOGIC_VECTOR (1 downto 0);
       FROM_IMMED  : in  STD_LOGIC_VECTOR (9 downto 0);
       FROM_STACK  : in  STD_LOGIC_VECTOR (9 downto 0);
       PC_COUNT    : out STD_LOGIC_VECTOR (9 downto 0));
end component;
       
component prog_rom is
   port (     ADDRESS : in std_logic_vector(9 downto 0); 
       INSTRUCTION : out std_logic_vector(17 downto 0); 
               CLK : in std_logic);  
end component;       
       
begin

cnt : PC
    Port Map(
        CLK        => CLK,
        S1_EN      => S1_EN,
--        PC_INC     => PC_INC,
        PC_LD      => PC_LD,
        RST        => RST,
        PC_MUX_SEL => PC_MUX_SEL,
        FROM_IMMED => FROM_IMMED,
        FROM_STACK => FROM_STACK,
        PC_COUNT   => PC_COUNT_sig);
        
prog : prog_rom
    Port Map(
        ADDRESS     => PC_COUNT_sig,
        INSTRUCTION => INSTRUCTION,
        CLK         => CLK);
        
        PC_COUNT <= PC_COUNT_sig;
end Behavioral;