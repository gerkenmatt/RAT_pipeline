----------------------------------------------------------------------------------
-- Engineer: Kyle Wuerch & Chin Chao
--
-- Module Name: PC - Behavioral
-- Comments: This module is designed to store a count signal that
-- can be modified and incremented by outside signals
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port ( CLK      : in  STD_LOGIC;
           S1_EN    : in STD_LOGIC;
           S1_EN_2       : in STD_LOGIC;
--           PC_INC   : in  STD_LOGIC;
           PC_LD    : in  STD_LOGIC;
           RST      : in  STD_LOGIC;
           D_IN     : in  STD_LOGIC_VECTOR(9 downto 0);
           PC_COUNT : out STD_LOGIC_VECTOR(9 downto 0));
end ProgramCounter;

architecture Behavioral of ProgramCounter is

signal count_sig : STD_LOGIC_VECTOR(9 downto 0) := "00" & x"00";

begin

counter: process(CLK, S1_EN, S1_EN_2)
begin
--    if(RISING_EDGE(CLK)S1_EN_2 = '0') then
--        count_sig <= count_sig - 1;
--    if(FALLING_EDGE(S1_EN_2))then
--        count_sig <= count_sig -1;
--    end if;    
    if(RISING_EDGE(CLK)) then
        if(PC_LD = '1')  then 
            count_sig <= D_IN; 
        end if;
    end if;
    if(RISING_EDGE(CLK) and (S1_EN = '1') and (S1_EN_2 = '1')) then
        if(RST = '1')       then count_sig <= "00" & x"00";
        elsif(PC_LD = '1')  then count_sig <= D_IN;
--        elsif(PC_INC = '1') then count_sig <= count_sig + 1;
        else count_sig <= count_sig + 1;
        end if;
    end if;
end process counter;

PC_COUNT <= count_sig;

end Behavioral;
