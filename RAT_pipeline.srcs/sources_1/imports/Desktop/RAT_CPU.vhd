----------------------------------------------------------------------------------
-- Module:   RAT_CPU
-- Engineer: Kyle Wuerch & Chin Chao
-- Comments: This module is the upper level module that connects the
--           control unit, reg_file, alu, flags, scr, sp, prog_rom, and pc
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity RAT_CPU is
    Port ( IN_PORT    : in  STD_LOGIC_VECTOR (7 downto 0);
           RST        : in  STD_LOGIC;
           CLK        : in  STD_LOGIC;
           INT_IN     : in  STD_LOGIC;
           OUT_PORT   : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID    : out  STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB    : out  STD_LOGIC);
end RAT_CPU;

architecture Behavioral of RAT_CPU is

   component pipeline_sec1 is  
       Port ( CLK     : in  STD_LOGIC;
          PC_INC      : in  STD_LOGIC;
          PC_LD       : in  STD_LOGIC;
          RST         : in  STD_LOGIC;
          PC_MUX_SEL  : in  STD_LOGIC_VECTOR (1 downto 0);
          FROM_IMMED  : in  STD_LOGIC_VECTOR (9 downto 0);
          FROM_STACK  : in  STD_LOGIC_VECTOR (9 downto 0);
          PC_COUNT    : out STD_LOGIC_VECTOR (9 downto 0);
          INSTRUCTION : out std_logic_vector(17 downto 0));
     
   end component;
   
   component pipeline_sec234 is
       Port ( CLK     : in  STD_LOGIC;
         INT_IN       : in STD_LOGIC;
         RESET        : in STD_LOGIC;
         PC_COUNT     : in  STD_LOGIC_VECTOR(9 downto 0);
         IN_PORT      : in STD_LOGIC_VECTOR(7 downto 0);
         INSTRUCTION  : in  STD_LOGIC_VECTOR(17 downto 0);
         PC_INC      : out  STD_LOGIC;
         PC_LD       : out  STD_LOGIC;
         RST         : out  STD_LOGIC;
         IO_STRB     : out STD_LOGIC;
         PC_MUX_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
         PORT_ID     : out STD_LOGIC_VECTOR (7 downto 0);
         OUT_PORT    : out STD_LOGIC_VECTOR (7 downto 0);
         FROM_IMMED  : out  STD_LOGIC_VECTOR (9 downto 0);
         FROM_STACK  : out  STD_LOGIC_VECTOR (9 downto 0));
   end component;

signal PC_INC_sig : STD_LOGIC;   
signal PC_LD_sig : STD_LOGIC;   
signal PC_MUX_sel_sig : STD_LOGIC_VECTOR(1 downto 0);   
signal FROM_IMMED_sig : STD_LOGIC_VECTOR(9 downto 0);   
signal FROM_STACK_sig : STD_LOGIC_VECTOR(9 downto 0);   
signal PC_COUNT_sig : STD_LOGIC_VECTOR(9 downto 0);   
signal INSTRUCTION_sig : STD_LOGIC_VECTOR(17 downto 0);   

signal s_rst : STD_LOGIC;

begin

pipe1 : pipeline_sec1
    Port Map(
        CLK             => CLK,
        PC_INC          => PC_INC_sig,
        PC_LD           => PC_LD_sig,
        RST             => s_rst,
        PC_MUX_SEL      => PC_MUX_SEL_sig,
        FROM_IMMED      => FROM_IMMED_sig,
        FROM_STACK      => FROM_STACK_sig,
        PC_COUNT        => PC_COUNT_sig,
        INSTRUCTION     => INSTRUCTION_sig);

pipe234 : pipeline_sec234 
    Port Map(
        CLK             => CLK,
        INT_IN          => INT_IN,
        RESET           => RST,
        PC_COUNT        => PC_COUNT_sig,
        IN_PORT         => IN_PORT,
        INSTRUCTION     => INSTRUCTION_sig,
        PC_INC          => PC_INC_sig,
        PC_LD           => PC_LD_sig,
        RST             => s_rst,
        IO_STRB         => IO_STRB,
        PC_MUX_SEL      => PC_MUX_SEL_sig,
        PORT_ID         => PORT_ID,
        OUT_PORT        => OUT_PORT,
        FROM_IMMED      => FROM_IMMED_sig,
        FROM_STACK      => FROM_STACK_sig);


end Behavioral;
