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

   component stage1 is  
       Port ( 
          CLK     : in  STD_LOGIC;
          PC_INC      : in  STD_LOGIC;
          PC_LD       : in  STD_LOGIC;
          RST         : in  STD_LOGIC;
          PC_MUX_SEL  : in  STD_LOGIC_VECTOR (1 downto 0);
          FROM_IMMED  : in  STD_LOGIC_VECTOR (9 downto 0);
          FROM_STACK  : in  STD_LOGIC_VECTOR (9 downto 0);
          PC_COUNT    : out STD_LOGIC_VECTOR (9 downto 0);
          INSTRUCTION : out std_logic_vector(17 downto 0));
     
   end component;
   
   component stage2 is
       Port (CLK     : in  STD_LOGIC;
         INT_IN       : in STD_LOGIC;
         RESET        : in  STD_LOGIC;
         IN_PORT      : in STD_LOGIC_VECTOR(7 downto 0);
         INSTRUCTION  : in  STD_LOGIC_VECTOR(17 downto 0);
         C_FLAG       : in STD_LOGIC;
         Z_FLAG       : in STD_LOGIC;
         ALU_RES      : in   STD_LOGIC_VECTOR (7 downto 0);
         SCR_OUT      : in   STD_LOGIC_VECTOR (9 downto 0);
         SP_OUT       : in   STD_LOGIC_VECTOR (7 downto 0);
         PC_INC       : out  STD_LOGIC;
         PC_LD        : out  STD_LOGIC;
         PC_MUX_SEL   : out  STD_LOGIC_VECTOR (1 downto 0);
         ALU_OPY_SEL  : out  STD_LOGIC;
         ALU_SEL      : out  STD_LOGIC_VECTOR (3 downto 0);
         SP_LD        : out  STD_LOGIC;
         SP_INCR      : out  STD_LOGIC;
         SP_DECR      : out  STD_LOGIC;
         FLG_C_SET    : out  STD_LOGIC;
         FLG_C_CLR    : out  STD_LOGIC;
         FLG_C_LD     : out  STD_LOGIC;
         FLG_Z_LD     : out  STD_LOGIC;
         FLG_LD_SEL   : out  STD_LOGIC;
         FLG_SHAD_LD  : out  STD_LOGIC;
         SCR_WE       : out  STD_LOGIC;
         SCR_ADDR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
         SCR_DATA_SEL : out STD_LOGIC;
         RST          : out STD_LOGIC;
         DX_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
         DY_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
         RF_D_IN      : out STD_LOGIC_VECTOR (7 downto 0);
         IO_STRB      : out STD_LOGIC;
         PORT_ID      : out STD_LOGIC_VECTOR (7 downto 0));
   end component;
   
   component stage34 is
        Port (CLK     : in  STD_LOGIC;
         INSTRUCTION  : in  STD_LOGIC_VECTOR(17 downto 0);
         ALU_SEL      : in STD_LOGIC_VECTOR(3 downto 0);
         ALU_OPY_SEL  : in STD_LOGIC;
         RST          : in STD_LOGIC;
         SP_LD        : in STD_LOGIC;
         SP_INCR      : in STD_LOGIC;
         SP_DECR      : in STD_LOGIC;
         DX_OUT       : in STD_LOGIC_VECTOR (7 downto 0);
         DY_OUT       : in STD_LOGIC_VECTOR (7 downto 0);
         PC_COUNT     : in STD_LOGIC_VECTOR (9 downto 0);
         SCR_DATA_SEL : in STD_LOGIC;
         SCR_WE       : in STD_LOGIC;
         SCR_ADDR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
         FLG_C_SET    : in STD_LOGIC;
         FLG_C_CLR    : in STD_LOGIC;
         FLG_C_LD     : in STD_LOGIC;
         FLG_Z_LD     : in STD_LOGIC;
         FLG_LD_SEL   : in STD_LOGIC;
         FLG_SHAD_LD  : in STD_LOGIC;
         C_FLAG_IN    : in STD_LOGIC;
         C_FLAG       : out STD_LOGIC;
         Z_FLAG       : out STD_LOGIC;
         ALU_RES      : out STD_LOGIC_VECTOR (7 downto 0);
         FROM_IMMED   : out STD_LOGIC_VECTOR (9 downto 0);
         FROM_STACK   : out STD_LOGIC_VECTOR (9 downto 0);
         SP_OUT       : out STD_LOGIC_VECTOR (7 downto 0));
   end component;



-----------------------------------------------------------------
-- PC signals
-----------------------------------------------------------------
signal PC_INC_sig : STD_LOGIC;   
signal PC_LD_sig : STD_LOGIC;   
signal PC_MUX_sel_sig : STD_LOGIC_VECTOR(1 downto 0);
signal PC_COUNT_sig : STD_LOGIC_VECTOR(9 downto 0);   
signal INSTRUCTION_sig : STD_LOGIC_VECTOR(17 downto 0); 

signal FROM_IMMED_sig : STD_LOGIC_VECTOR(9 downto 0);   
signal FROM_STACK_sig : STD_LOGIC_VECTOR(9 downto 0);  
-----------------------------------------------------------------



-----------------------------------------------------------------
-- ALU signals
-----------------------------------------------------------------
signal ALU_OPY_SEL_sig : STD_LOGIC;
signal ALU_SEL_sig : STD_LOGIC_VECTOR(3 downto 0);
-----------------------------------------------------------------



-----------------------------------------------------------------
-- SP signals
-----------------------------------------------------------------
signal SP_LD_sig : STD_LOGIC;
signal SP_INCR_sig : STD_LOGIC;
signal SP_DECR_sig : STD_LOGIC;
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Flag signals
-----------------------------------------------------------------
signal C_FLAG_sig : STD_LOGIC;
signal C_FLAG_IN_sig : STD_LOGIC;

signal FLG_C_SET_sig : STD_LOGIC;
signal FLG_C_CLR_sig : STD_LOGIC;
signal FLG_C_LD_sig : STD_LOGIC;

signal Z_FLAG_sig : STD_LOGIC;
signal FLG_Z_LD_sig : STD_LOGIC;

signal FLG_LD_SEL_sig : STD_LOGIC;
signal FLG_SHAD_LD_sig : STD_LOGIC;
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Scratch ram signals
-----------------------------------------------------------------
signal SCR_WE_sig : STD_LOGIC;
signal SCR_DATA_SEL_sig : STD_LOGIC;
signal SCR_ADDR_SEL_sig : STD_LOGIC_VECTOR(1 downto 0);
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Register file signals
-----------------------------------------------------------------
signal DX_OUT_sig : STD_LOGIC_VECTOR(7 downto 0);
signal DY_OUT_sig : STD_LOGIC_VECTOR(7 downto 0);
signal RF_D_IN_sig : STD_LOGIC_VECTOR(7 downto 0);

signal ALU_RES_sig : STD_LOGIC_VECTOR(7 downto 0);
signal SCR_OUT_sig : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');  
signal SP_OUT_sig : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');   
-----------------------------------------------------------------

  

signal s_rst : STD_LOGIC;



begin

fetch : stage1
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

decode : stage2
    Port Map(
        CLK             => CLK,
        INT_IN          => INT_IN,
        RESET           => RST,
        IN_PORT         => IN_PORT,
        INSTRUCTION     => INSTRUCTION_sig,
        C_FLAG          => C_FLAG_sig,
        Z_FLAG          => Z_FLAG_sig,
        ALU_RES         => ALU_RES_sig,
        SCR_OUT         => SCR_OUT_sig,
        SP_OUT          => SP_OUT_sig,
        PC_INC          => PC_INC_sig,
        PC_LD           => PC_LD_sig,
        PC_MUX_SEL      => PC_MUX_SEL_sig,
        ALU_OPY_SEL     => ALU_OPY_SEL_sig,
        ALU_SEL         => ALU_SEL_sig,
        SP_LD           => SP_LD_sig,
        SP_INCR         => SP_INCR_sig,
        SP_DECR         => SP_DECR_sig,
        FLG_C_SET       => FLG_C_SET_sig,
        FLG_C_CLR       => FLG_C_CLR_sig,
        FLG_C_LD        => FLG_C_LD_sig,
        FLG_Z_LD        => FLG_Z_LD_sig,
        FLG_LD_SEL      => FLG_LD_SEL_sig,
        FLG_SHAD_LD     => FLG_SHAD_LD_sig,
        SCR_WE          => SCR_WE_sig,
        SCR_ADDR_SEL    => SCR_ADDR_SEL_sig,
        SCR_DATA_SEL    => SCR_DATA_SEL_sig,
        RST             => s_rst,
        DX_OUT          => DX_OUT_sig,
        DY_OUT          => DY_OUT_sig,
        RF_D_IN         => RF_D_IN_sig,
        IO_STRB         => IO_STRB,
        PORT_ID         => PORT_ID);
 
exwr : stage34
    Port Map(CLK      => CLK,
        INSTRUCTION   => INSTRUCTION_sig,
        ALU_SEL       => ALU_SEL_sig,
        ALU_OPY_SEL   => ALU_OPY_SEL_sig,
        RST           => RST,
        SP_LD         => SP_LD_sig,
        SP_INCR       => SP_INCR_sig,
        SP_DECR       => SP_DECR_sig,
        DX_OUT        => DX_OUT_sig,
        DY_OUT        => DY_OUT_sig,
        PC_COUNT      => PC_COUNT_sig,
        SCR_DATA_SEL  => SCR_DATA_SEL_sig,
        SCR_WE        => SCR_WE_sig,
        SCR_ADDR_SEL  => SCR_ADDR_SEL_sig,
        FLG_C_SET     => FLG_C_SET_sig,
        FLG_C_CLR     => FLG_C_CLR_sig,
        FLG_C_LD      => FLG_C_LD_sig,
        FLG_Z_LD      => FLG_Z_LD_sig,
        FLG_LD_SEL    => FLG_LD_SEL_sig,
        FLG_SHAD_LD   => FLG_SHAD_LD_sig,
        C_FLAG_IN     => C_FLAG_IN_sig,
        C_FLAG        => C_FLAG_sig,
        Z_FLAG        => Z_FLAG_sig,
        ALU_RES       => ALU_RES_sig,
        FROM_IMMED    => FROM_IMMED_sig,
        FROM_STACK    => FROM_STACK_sig,
        SP_OUT        => SP_OUT_sig);
        
    SCR_OUT_sig <= FROM_STACK_sig;
    C_FLAG_IN_sig <= C_FLAG_sig;
    OUT_PORT <= DX_OUT_sig(7 downto 0);

end Behavioral;
