----------------------------------------------------------------------------------
-- Engineer: Kyle Wuerch & Chin Chao
--
-- Module Name: SCRATCH_RAM_SIM
-- Comments: This module is designed to test the functionality of
-- the SCRATCH_RAM
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY CPU_SIM IS
END CPU_SIM;
 
ARCHITECTURE behavior OF CPU_SIM IS 
    -- Component Declaration for the Unit Under Test (UUT)
    
    component RAT_CPU is
        Port ( IN_PORT    : in  STD_LOGIC_VECTOR (7 downto 0);
               RST        : in  STD_LOGIC;
               CLK        : in  STD_LOGIC;
               INT_IN     : in  STD_LOGIC;
               OUT_PORT   : out  STD_LOGIC_VECTOR (7 downto 0);
               PORT_ID    : out  STD_LOGIC_VECTOR (7 downto 0);
               IO_STRB    : out  STD_LOGIC);
    end component;

   --Inputs
   signal CLK_tb         : STD_LOGIC;
   signal RST_tb         : STD_LOGIC;
   signal IN_PORT_tb     : STD_LOGIC_VECTOR(7 downto 0) := x"07";
   signal INT_IN_tb       : STD_LOGIC;

   
   --Outputs
   signal PORT_ID_tb     : STD_LOGIC_VECTOR(7 downto 0);
   signal OUT_PORT_tb    : STD_LOGIC_VECTOR(7 downto 0);
   signal IO_STRB_tb     : STD_LOGIC;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
        
uut: RAT_CPU
    Port Map(
        IN_PORT  => IN_PORT_tb,
        RST      => RST_tb,
        CLK      => CLK_tb,
        INT_IN   => INT_IN_tb,
        OUT_PORT => OUT_PORT_tb,
        PORT_ID  => PORT_ID_tb,
        IO_STRB  => IO_STRB_tb
    );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK_tb <= '0';
		wait for CLK_period/2;
		CLK_tb <= '1';
		wait for CLK_period/2;
   end process;	
   
   -- verify memory
   VERIFY_process :process
   begin
      RST_tb <= '1';
      wait for 10 ns;
      RST_tb <= '0';
      wait for 360 ns;    
      INT_IN_tb <= '1';
      wait for 30 ns;
      INT_IN_tb <= '0';
      wait for 1000 ns;           
   end process VERIFY_process;
END;
