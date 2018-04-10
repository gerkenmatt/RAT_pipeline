----------------------------------------------------------------------------------
-- Module Name: SYS_WRAPPER
-- Engineers: Kyle Wuerch & Chin Chao
-- Comments: This module is the top level module that directly interfaces
--           with the Basys3 Board
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYS_WRAPPER is
    Port ( CLK      : in  STD_LOGIC;
           RST      : in  STD_LOGIC;
           INT      : in  STD_LOGIC;
           SWITCHES : in  STD_LOGIC_VECTOR (15 downto 0);
           LEDS     : out STD_LOGIC_VECTOR (15 downto 0);
           SSEG     : out STD_LOGIC_VECTOR (7 downto 0);
           DISP     : out STD_LOGIC_VECTOR (3 downto 0));
end SYS_WRAPPER;

architecture Behavioral of SYS_WRAPPER is

signal s_clk_div     : STD_LOGIC := '0';

signal s_sseg_cr     : STD_LOGIC_VECTOR(7 downto 0)  := X"00";
signal s_sseg_count1 : STD_LOGIC_VECTOR(13 downto 0) := "00" & X"000";
signal s_sseg_count2 : STD_LOGIC_VECTOR(7 downto 0)  := X"00";

signal s_interrupt   : STD_LOGIC := '0';

-- Declare RAT_wrapper ------------------------------------------------------
component RAT_wrapper
    Port ( LEDS      : out   STD_LOGIC_VECTOR (15 downto 0);
           SSEG_VAL1 : out   STD_LOGIC_VECTOR (13 downto 0);
           SSEG_VAL2 : out   STD_LOGIC_VECTOR (7 downto 0);
           SSEG_CR   : out   STD_LOGIC_VECTOR (7 downto 0);
           SWITCHES  : in    STD_LOGIC_VECTOR (15 downto 0);
           INT       : in    STD_LOGIC;
           RST       : in    STD_LOGIC;
           CLK       : in    STD_LOGIC);
end component;
------------------------------------------------------------------------------ 

-- Declare MAIN_CLK_DIV ------------------------------------------------------
component MAIN_CLK_DIV is
    Port ( CLK  : in  STD_LOGIC;
           SCLK : out STD_LOGIC);
end component MAIN_CLK_DIV;
------------------------------------------------------------------------------ 

-- Declare db_1shot_FSM ------------------------------------------------------
component db_1shot_FSM
      Port ( A    : in STD_LOGIC;
             CLK  : in STD_LOGIC;
             A_DB : out STD_LOGIC);
end component;
------------------------------------------------------------------------------ 

-- Declare sseg_dec -----------------------------------------------------------  
component sseg_dec_uni
    Port ( COUNT1   : in std_logic_vector(13 downto 0); 
           COUNT2   : in std_logic_vector(7 downto 0);
           SEL      : in std_logic_vector(1 downto 0);
           dp_oe    : in std_logic;
           dp       : in std_logic_vector(1 downto 0);                       
           CLK      : in std_logic;
           SIGN     : in std_logic;
           VALID    : in std_logic;
           DISP_EN  : out std_logic_vector(3 downto 0);
           SEGMENTS : out std_logic_vector(7 downto 0));
end component;
------------------------------------------------------------------------------ 

begin

-- Instantiate RAT_WRAPPER --------------------------------------------------
rat: RAT_wrapper
    Port Map(
        LEDS      => LEDS,
        SSEG_VAL1 => s_sseg_count1,
        SSEG_VAL2 => s_sseg_count2,
        SSEG_CR   => s_sseg_cr,
        SWITCHES  => SWITCHES,
        INT       => s_interrupt,
        RST       => RST,
        CLK       => s_clk_div);
------------------------------------------------------------------------------        
   
-- Instantiate MAIN_CLK_DIV --------------------------------------------------
div: MAIN_CLK_DIV
    port map ( 
        CLK  => CLK,
        SCLK => s_clk_div);
------------------------------------------------------------------------------

-- Instantiate db_1shot_FSM --------------------------------------------------              
   my_debouncer: db_1shot_FSM
   port map ( A    => INT,
              CLK  => s_clk_div,
              A_DB => s_interrupt);
------------------------------------------------------------------------------
              
-- Instantiate sseg_dec -------------------------------------------------------   
sg: sseg_dec_uni
    port map ( 
        COUNT1   => s_sseg_count1,
        COUNT2   => s_sseg_count2,
        SEL      => s_sseg_cr(7 downto 6),
        dp_oe    => s_sseg_cr(2),
        dp       => s_sseg_cr(5 downto 4),                       
        CLK      => CLK,
        SIGN     => s_sseg_cr(1),
        VALID    => s_sseg_cr(0),
        DISP_EN  => DISP,
        SEGMENTS => SSEG);
   ------------------------------------------------------------------------------
end Behavioral;
