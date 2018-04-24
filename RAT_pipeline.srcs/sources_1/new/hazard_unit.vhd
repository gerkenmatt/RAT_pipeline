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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_unit is
  Port (CLK             : in STD_LOGIC;
        INSTR           : in STD_LOGIC_VECTOR(17 downto 0);
        PREV_INSTR      : in STD_LOGIC_VECTOR(17 downto 0);
    
        PC_CLK          : out STD_LOGIC;
        B1_CLK          : out STD_LOGIC;
        PREV_INSTR_OUT  : out STD_LOGIC_VECTOR(17 downto 0);
        INSTR_OUT       : out STD_LOGIC_VECTOR(17 downto 0));
        
end hazard_unit;

architecture Behavioral of hazard_unit is


signal s_prev_instr           : STD_LOGIC_VECTOR(17 downto 0);
signal stall_flag             : STD_LOGIC := '0';
signal branch_flag            : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal s_temp_instr           : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');

alias src_reg : STD_LOGIC_VECTOR(4 downto 0) is INSTR (7 downto 3);
alias dst_reg : STD_LOGIC_VECTOR(4 downto 0) is PREV_INSTR (12 downto 8);
alias OP_HI : STD_LOGIC_VECTOR(4 downto 0) is INSTR (17 downto 13);



begin

    stall: process(CLK)
    begin
        if(RISING_EDGE(CLK)) then
            s_prev_instr <= INSTR;
            s_temp_instr <= INSTR;
            if (src_reg = dst_reg and PREV_INSTR /= "000000000000000000") then            
                if (stall_flag = '1') then
                    PC_CLK <= '1';
                    B1_CLK <= '1';
                    stall_flag <= '0';
                else
                    PC_CLK <= '0';
                    B1_CLK <= '0';
                    s_temp_instr(17 downto 13) <= "11111";--no op
                    s_temp_instr(1 downto 0) <= "11";
                    stall_flag <= '1';
                end if;
            elsif ((OP_HI = "00100") or (OP_HI = "00101") or (OP_HI = "01100")) then 
                if (branch_flag = "10") then
                    PC_CLK <= '1'; 
                    branch_flag <= "00";
                elsif (branch_flag = "01") then
                    PC_CLK <= '0';
                    branch_flag <= "10";
                else
                    PC_CLK <= '0';
                    branch_flag <= "01";
                end if;
            else
                PC_CLK <= '1';
                B1_CLK <= '1';
            end if;   
        end if;
    end process stall;
    
    INSTR_OUT       <= s_temp_instr;
    PREV_INSTR_OUT  <= s_prev_instr;


end Behavioral;

