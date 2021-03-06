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
        PC_CLK_2        : out STD_LOGIC;
        B1_CLK          : out STD_LOGIC;
        PREV_INSTR_OUT  : out STD_LOGIC_VECTOR(17 downto 0);
        INSTR_OUT       : out STD_LOGIC_VECTOR(17 downto 0));
        
end hazard_unit;

architecture Behavioral of hazard_unit is

signal s_prev_instr           : STD_LOGIC_VECTOR(17 downto 0);
signal stall_flag             : STD_LOGIC := '0';
signal data_ind             : STD_LOGIC := '0';
signal data_flag            : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal s_temp_instr           : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
signal s_d_p2_clk               : STD_LOGIC := '1';
signal s_p2_clk               : STD_LOGIC := '1';
signal s_pc_ld              : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal ophi : STD_LOGIC_VECTOR(4 downto 0):= (others => '0');

alias src_reg : STD_LOGIC_VECTOR(4 downto 0) is INSTR (7 downto 3);
alias cur_dst_reg : STD_LOGIC_VECTOR(4 downto 0) is INSTR (12 downto 8);
alias dst_reg : STD_LOGIC_VECTOR(4 downto 0) is PREV_INSTR (12 downto 8);
alias OP_HI : STD_LOGIC_VECTOR(4 downto 0) is INSTR (17 downto 13);



begin

    stall: process(CLK)
    begin
        if(RISING_EDGE(CLK)) then
            s_prev_instr <= INSTR;
            s_temp_instr <= INSTR;
            if (data_flag = "11") then
                PC_CLK <= '1'; 
                B1_CLK <= '1';
                s_temp_instr(17 downto 13) <= "11111";--no op 
                s_temp_instr(1 downto 0) <= "11";
                s_prev_instr <= PREV_INSTR;
                data_flag <= "00";
            elsif (data_flag = "10") then
                PC_CLK <= '1';
                B1_CLK <= '1';
                s_temp_instr <= PREV_INSTR;
                s_prev_instr <= PREV_INSTR;
                data_flag <= "11";
            elsif (data_flag = "01") then
                PC_CLK <= '0';
                B1_CLK <= '0';
                s_temp_instr(17 downto 13) <= "11111";--no op 
                s_temp_instr(1 downto 0) <= "11";
                s_prev_instr <= PREV_INSTR;
                data_flag <= "10";
            else
                PC_CLK <= '1';
                B1_CLK <= '1';
            end if;
            if (data_ind = '1') then
                    PC_CLK <= '0';
                    B1_CLK <= '0';
                    s_temp_instr(17 downto 13) <= "11111";--no op 
                    s_temp_instr(1 downto 0) <= "11";
                    data_flag <= "01";
            end if;
        end if;
    end process stall;
      
    comb2: process(CLK)
            begin
            if(FALLING_EDGE(CLK)) then
                if (((src_reg = dst_reg) or (cur_dst_reg = dst_reg)) and PREV_INSTR /= "000000000000000000" and
                (data_flag = "00") and (OP_HI /="11011") and (PREV_INSTR(17 downto 13) /= "00100")
                and (PREV_INSTR(17 downto 13) /= "00101") and (OP_HI /="00100") and (OP_HI /="00101") and
                (OP_HI /="01100")) then
                    s_d_p2_clk <= '0';
                    data_ind <= '1';
                end if;
                if (data_flag="01") then
                   s_d_p2_clk <= '1';
                   data_ind <='0';
               end if;
            end if;
        end process comb2;
        
    ophi <= OP_HI;
    s_p2_clk <=  (s_d_p2_clk);
    INSTR_OUT       <= s_temp_instr;
    PREV_INSTR_OUT  <= s_prev_instr;
    PC_CLK_2        <= s_p2_clk;

end Behavioral;



