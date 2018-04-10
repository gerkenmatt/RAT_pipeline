----------------------------------------------------------------------------------
-- Module Name: RAT_WRAPPER
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAT_wrapper is
    Port ( LEDS      : out   STD_LOGIC_VECTOR (15 downto 0);
           SSEG_VAL1 : out   STD_LOGIC_VECTOR (13 downto 0);
           SSEG_VAL2 : out   STD_LOGIC_VECTOR (7 downto 0);
           SSEG_CR   : out   STD_LOGIC_VECTOR (7 downto 0);
           SWITCHES  : in    STD_LOGIC_VECTOR (15 downto 0);
           INT       : in    STD_LOGIC;
           RST       : in    STD_LOGIC;
           CLK       : in    STD_LOGIC);
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is    
   -- INPUT PORT IDS -------------------------------------------------------------
   -- Right now, the only possible inputs are the switches
   -- In future labs you can add more port IDs, and you'll have
   -- to add constants here for the mux below
   CONSTANT SWITCHES_ID1 : STD_LOGIC_VECTOR (7 downto 0) := X"20";
   CONSTANT SWITCHES_ID2 : STD_LOGIC_VECTOR (7 downto 0) := X"21";
   -------------------------------------------------------------------------------
   
   -------------------------------------------------------------------------------
   -- OUTPUT PORT IDS ------------------------------------------------------------
   -- In future labs you can add more port IDs
   CONSTANT LEDS_ID1        : STD_LOGIC_VECTOR (7 downto 0) := X"40";
   CONSTANT LEDS_ID2        : STD_LOGIC_VECTOR (7 downto 0) := X"3F";
   
   CONSTANT SSEG_CR_ID      : STD_LOGIC_VECTOR (7 downto 0) := X"41";
   CONSTANT SSEG_VAL1_ID1   : STD_LOGIC_VECTOR (7 downto 0) := x"42";
   CONSTANT SSEG_VAL1_ID2   : STD_LOGIC_VECTOR (7 downto 0) := X"43";
   CONSTANT SSEG_VAL2_ID    : STD_LOGIC_VECTOR (7 downto 0) := X"44";
   -------------------------------------------------------------------------------

   -- Declare RAT_CPU ------------------------------------------------------------
   component RAT_CPU 
       Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
              OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
              PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
              IO_STRB  : out STD_LOGIC;
              RST      : in  STD_LOGIC;
              INT_IN   : in  STD_LOGIC;
              CLK      : in  STD_LOGIC);
   end component RAT_CPU;
   -------------------------------------------------------------------------------
      
   -- Signals for connecting RAT_CPU to RAT_wrapper -------------------------------
   signal s_input_port  : std_logic_vector (7 downto 0);
   signal s_output_port : std_logic_vector (7 downto 0);
   signal s_port_id     : std_logic_vector (7 downto 0);
   signal s_load        : std_logic;
   --signal s_interrupt   : std_logic; -- not yet used
   
   -- Register definitions for output devices ------------------------------------
   signal r_LEDS         : std_logic_vector (15 downto 0) := X"0000"; 
   signal r_SSEG_CR      : std_logic_vector (7 downto 0)  := X"00";
   signal r_SSEG_VAL1    : std_logic_vector (13 downto 0) := "000000" & X"00";
   signal r_SSEG_VAL2    : std_logic_vector (7 downto 0)  := X"00";
   -------------------------------------------------------------------------------

begin
   
   -- Instantiate RAT_CPU --------------------------------------------------------
   CPU: RAT_CPU
   port map(  IN_PORT  => s_input_port,
              OUT_PORT => s_output_port,
              PORT_ID  => s_port_id,
              RST      => RST,  
              IO_STRB  => s_load,
              INT_IN   => INT,
              CLK      => CLK);         
   -------------------------------------------------------------------------------
      
   ------------------------------------------------------------------------------- 
   -- MUX for selecting what input to read ---------------------------------------
   -------------------------------------------------------------------------------
   inputs: process(s_port_id, SWITCHES)
   begin
      if (s_port_id = SWITCHES_ID1) then
         s_input_port <= SWITCHES(7 downto 0);
      elsif (s_port_id = SWITCHES_ID2) then
         s_input_port <= SWITCHES(15 downto 8);
      else
         s_input_port <= x"00";
      end if;
   end process inputs;
   -------------------------------------------------------------------------------


   -------------------------------------------------------------------------------
   -- MUX for updating output registers ------------------------------------------
   -- Register updates depend on rising clock edge and asserted load signal
   -------------------------------------------------------------------------------
   outputs: process(CLK) 
   begin   
      if (rising_edge(CLK)) then
         if (s_load = '1') then 
            -- the register definition for the LEDS
            if (s_port_id = LEDS_ID1) then
               r_LEDS <= r_LEDS(15 downto 8) & s_output_port;
            elsif(s_port_id = LEDS_ID2) then
               r_LEDS <= s_output_port & r_LEDS(7 downto 0);
            elsif(s_port_id = SSEG_CR_ID) then
               r_SSEG_CR <= s_output_port;
            elsif(s_port_id = SSEG_VAL1_ID1) then
               r_SSEG_VAL1 <= r_SSEG_VAL1(13 downto 8) & s_output_port;
            elsif(s_port_id = SSEG_VAL1_ID2) then
               r_SSEG_VAL1 <= s_output_port(5 downto 0) & r_SSEG_VAL1(7 downto 0);
            elsif(s_port_id = SSEG_VAL2_ID) then
               r_SSEG_VAL2 <= s_output_port;
            end if;
         end if; 
      end if;
   end process outputs;      
   -------------------------------------------------------------------------------
   
   -- Register Interface Assignments ---------------------------------------------
   LEDS      <= r_LEDS;
   SSEG_VAL1 <= r_SSEG_VAL1;
   SSEG_VAL2 <= r_SSEG_VAL2;
   SSEG_CR   <= r_SSEG_CR;

end Behavioral;
