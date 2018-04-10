----------------------------------------------------------------------------------
-- Module Name: Control Unit
-- Engineers: Kyle Wuerch & Chin Chao
-- Comments: This module is the flag register for the interrupt flag
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity I_FLAG is
    Port ( I_SET : in STD_LOGIC;
           I_CLR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           I_OUT : out STD_LOGIC);
end I_FLAG;

architecture Behavioral of I_FLAG is

component FlagReg is
    Port ( IN_FLAG  : in  STD_LOGIC; --flag input
           LD       : in  STD_LOGIC; --load the out_flag with the in_flag value
           SET      : in  STD_LOGIC; --set the flag to '1'
           CLR      : in  STD_LOGIC; --clear the flag to '0'
           CLK      : in  STD_LOGIC; --system clock
           OUT_FLAG : out  STD_LOGIC); --flag output
end component FlagReg;

begin
I_REG : FlagReg
    port map(
        IN_FLAG  => '0',
        LD       => '0',
        SET      => I_SET,
        CLR      => I_CLR,
        CLK      => CLK,
        OUT_FLAG => I_OUT);

end Behavioral;
