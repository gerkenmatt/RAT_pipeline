----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2018 06:41:50 PM
-- Design Name: 
-- Module Name: buffer1 - Behavioral
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

entity buffer1 is
  Port (CLK         : in  STD_LOGIC;
        IR_IN       : in STD_LOGIC_VECTOR(17 downto 0);
        PC_CNT_IN   : in STD_LOGIC_VECTOR(9 downto 0);
        IR_OUT      : out STD_LOGIC_VECTOR(17 downto 0); 
        PC_CNT_OUT  : out STD_LOGIC_VECTOR(9 downto 0));
end buffer1;

architecture Behavioral of buffer1 is

signal ir_sig : STD_LOGIC_VECTOR(17 downto 0);
signal pc_sig : STD_LOGIC_VECTOR(9 downto 0);

begin

counter: process(CLK)
begin
    if(RISING_EDGE(CLK)) then
        ir_sig <= IR_IN;
        pc_sig <= PC_CNT_IN;
    end if;
end process counter;

IR_OUT <= ir_sig;
PC_CNT_OUT <= pc_sig;

end Behavioral;
