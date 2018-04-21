----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2018 03:39:57 PM
-- Design Name: 
-- Module Name: buffer3 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buffer3 is
  Port (CLK             : in STD_LOGIC;
        RF_WR_IN        : in STD_LOGIC;
        RF_WR_SEL_IN    : in STD_LOGIC_VECTOR(1 downto 0);
        ALU_RES_IN      : in STD_LOGIC_VECTOR(7 downto 0);
        SCR_DATA_IN     : in STD_LOGIC_VECTOR(9 downto 0);
        SP_DATA_IN      : in STD_LOGIC_VECTOR(7 downto 0);
        IR_IN           : in STD_LOGIC_VECTOR(17 downto 0);
        
        RF_WR_OUT       : out STD_LOGIC;
        RF_WR_SEL_OUT   : out STD_LOGIC_VECTOR(1 downto 0);
        ALU_RES_OUT     : out STD_LOGIC_VECTOR(7 downto 0);
        SCR_DATA_OUT    : out STD_LOGIC_VECTOR(9 downto 0);
        SP_DATA_OUT     : out STD_LOGIC_VECTOR(7 downto 0);
        IR_OUT          : out STD_LOGIC_VECTOR(17 downto 0));
end buffer3;

architecture Behavioral of buffer3 is

signal val : STD_LOGIC; 

begin

    latch: process(CLK)
    begin
        if(RISING_EDGE(CLK)) then
            val <= RF_WR_IN;
        end if;
    end process latch;
    
    RF_WR_OUT <= val;

end Behavioral;

