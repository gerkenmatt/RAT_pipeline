----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2018 08:58:57 AM
-- Design Name: 
-- Module Name: branch_pred - Behavioral
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

entity branch_pred is
  Port ( CLK            : in  STD_LOGIC;
        OPCODE_HI_5     : in  STD_LOGIC_VECTOR (4 downto 0);
        OPCODE_LO_2     : in  STD_LOGIC_VECTOR (1 downto 0);
        PREV_OP_CODE    : in  STD_LOGIC_VECTOR (6 downto 0);
        PC_CNT_T        : in  STD_LOGIC_VECTOR (9 downto 0);
        PC_CNT_NT       : in  STD_LOGIC_VECTOR (9 downto 0);
        C               : in  STD_LOGIC;
        C_SET           : in  STD_LOGIC;
        Z               : in  STD_LOGIC;
        DATA_NOP        : in  STD_LOGIC;
        DATA_PC_EN      : in  STD_LOGIC;
        
        PC_CNT_OUT      : out STD_LOGIC_VECTOR(9 downto 0);
        BR_PC_LD        : out STD_LOGIC;
        BR_NOP_CU       : out STD_LOGIC;
        INSTR_NULL      : out STD_LOGIC;
        INSTR_NULL2     : out STD_LOGIC
        
        );
        
end branch_pred;

architecture Behavioral of branch_pred is
    
    signal  s_op                : STD_LOGIC_VECTOR(6 downto 0);
    --TODO: make s_brn_wait into a state machine: NO_BRANCH, BRANCH_CHECK, BRANCH_NOP
    signal  s_brn_wait          : STD_LOGIC_VECTOR(1 downto 0) := (others => '0'); --not sure if this should be one or two bits
    -- signal  s_op_prev           : STD_LOGIC_VECTOR(6 downto 0);
    -- signal  s_op_tmp            : STD_LOGIC_VECTOR(6 downto 0);
    signal  s_pc_cnt_t_prev     : STD_LOGIC_VECTOR(9 downto 0);
    signal  s_pc_cnt_nt_prev    : STD_LOGIC_VECTOR(9 downto 0);
    signal  s_br_pred_cu        : STD_LOGIC;
    signal  s_br_nop_stall      : STD_LOGIC;
    signal  s_ret_null_flag     : STD_LOGIC;
    signal  s_brn_null_flag     : STD_LOGIC;

    
    TYPE state_type is (IDLE, BRN_VALID, BRN_STALL1, RET1, RET2, RET3, RET4, RET5, RET6, RET7);
    signal PS, NS : state_type;
    
    begin
    
        s_op <= OPCODE_HI_5 & OPCODE_LO_2;

        
        sync_process: process(CLK, OPCODE_HI_5, DATA_NOP)
            begin
                if (RISING_EDGE(CLK)) then
                    INSTR_NULL <= '0';
                    if (((OPCODE_HI_5 = "00101" or OPCODE_HI_5 = "00100") and PREV_OP_CODE /= "1111111")
                         or s_op = "0110010") then
                        INSTR_NULL <= '1';
                        if ((PREV_OP_CODE(6 downto 2) = "00100" or PREV_OP_CODE(6 downto 2) = "00101")
                             and (OPCODE_HI_5 = "00101" or OPCODE_HI_5 = "00100")) then 
                            s_ret_null_flag <= '1';
--                            INSTR_NULL <= '1';
                        end if;
                        if (s_op = "0110010" and DATA_PC_EN = '1') then
                            s_ret_null_flag <= '1';
                        end if;
                    end if;
                    if (s_ret_null_flag = '1') then
                        INSTR_NULL <= '1';
                        s_ret_null_flag <= '0';
                    end if;
                    if (s_brn_null_flag = '1') then
                        INSTR_NULL <= '1';
                        s_brn_null_flag <= '0';
                    end if;
                end if;
                if(FALLING_EDGE(CLK)) then
--                    s_op_prev   <= s_op_tmp;    
--                    s_op_tmp    <= s_op;
                    BR_PC_LD   <= '0';
--                    BR_NOP_CU   <= '0';         
                    BR_NOP_CU  <= '0';  
                    INSTR_NULL2 <= '0'; 
                    s_brn_null_flag <= '0';
                    case PS is
                        when IDLE =>                                           
                            if (s_br_nop_stall = '1') then
                                 BR_NOP_CU <= '1';
                                 s_br_nop_stall <= '0';
                            end if;
                            if (s_op = "0110010" and DATA_PC_EN = '1') then
                                 BR_NOP_CU <= '0';
                                 PS <= RET1;
                            end if;
                            if ((OPCODE_HI_5 = "00101" or OPCODE_HI_5 = "00100") and DATA_NOP = '0') then
                                 PS <= BRN_VALID;
                                 s_pc_cnt_t_prev     <= PC_CNT_T;
                                 s_pc_cnt_nt_prev    <= PC_CNT_NT;  
                                 BR_PC_LD           <= '1';     
                                 PC_CNT_OUT          <= PC_CNT_T; 
                                 s_brn_null_flag <= '1';
                                 
                                 case s_op is
                                     when "0010101" => -- BRCC --taken
                                          s_pc_cnt_t_prev     <= PC_CNT_T;
                                          s_pc_cnt_nt_prev    <= PC_CNT_NT;  
                                          BR_PC_LD           <= '1';     
                                          PC_CNT_OUT          <= PC_CNT_T; 
                                     when "0010100" => -- BRCS -- not taken
                                        s_pc_cnt_t_prev     <= PC_CNT_T;
                                        s_pc_cnt_nt_prev    <= PC_CNT_NT;  
                                        BR_PC_LD           <= '0';     
                                        PC_CNT_OUT          <= PC_CNT_NT; 
                                     when "0010010" => -- BREQ --not taken
                                         s_pc_cnt_t_prev     <= PC_CNT_T;
                                          s_pc_cnt_nt_prev    <= PC_CNT_NT;  
                                          BR_PC_LD           <= '0';     
                                          PC_CNT_OUT          <= PC_CNT_NT; 
                                     when "0010011" => -- BRNE --taken
                                         s_pc_cnt_t_prev     <= PC_CNT_T;
                                          s_pc_cnt_nt_prev    <= PC_CNT_NT;  
                                          BR_PC_LD           <= '1';     
                                          PC_CNT_OUT          <= PC_CNT_T; 
                                     when others => 
                                        s_pc_cnt_t_prev     <= PC_CNT_T;
                                        s_pc_cnt_nt_prev    <= PC_CNT_NT;  
                                        BR_PC_LD           <= '1';     
                                        PC_CNT_OUT          <= PC_CNT_T;  
                                         
                                 end case;
                                 -- take the branch every time
  
                            end if;
                        when BRN_VALID => 
     
                            --if branch was not taken
                            --flush subsequent stages
                            --and return to previous state
                            PS <= IDLE;
                            BR_NOP_CU <= '1';
--                            s_br_nop_stall <= '1';
                            if ((OPCODE_HI_5 = "00101" or OPCODE_HI_5 = "00100") and s_op /= PREV_OP_CODE) then
                                INSTR_NULL2 <= '1';
                            end if;
                            case PREV_OP_CODE is
                                when "0010101" => -- BRCC
                                    if(C = '1') then --if not taken
                                        BR_PC_LD <= '1';
                                        BR_NOP_CU  <= '1';
                                        PC_CNT_OUT <= s_pc_cnt_nt_prev ;    
                                        PS <= BRN_STALL1;  
                                        s_br_nop_stall <= '0';
                                    end if;
                                when "0010100" => -- BRCS
                                    if(C = '1' or C_SET = '1') then --if taken
                                        BR_PC_LD <= '1';
                                        BR_NOP_CU  <= '1';
                                        PC_CNT_OUT <= s_pc_cnt_t_prev;
                                        PS <= BRN_STALL1; 
                                        s_br_nop_stall <= '0';
                                    end if;
                                when "0010010" => -- BREQ
                                    if(Z = '1') then -- if taken
                                        BR_PC_LD  <= '1';
                                        BR_NOP_CU  <= '1';
                                        PC_CNT_OUT <= s_pc_cnt_t_prev;
                                        PS <= BRN_STALL1; 
                                        s_br_nop_stall <= '0';
                                    end if;
                                when "0010011" => -- BRNE
                                    if(Z = '1') then --if not taken
                                        BR_PC_LD  <= '1';
                                        BR_NOP_CU  <= '1';
                                        PC_CNT_OUT <= s_pc_cnt_nt_prev;
                                        PS <= BRN_STALL1; 
                                        s_br_nop_stall <= '0';
                                    end if;
                                when others => 
                                    BR_PC_LD  <= '0';
                                    BR_NOP_CU  <= '0';
                                    
                                end case;
                        --send no op to alu
--                        s_br_pred_cu <= '0';
                    when BRN_STALL1 => 
                          --send no op to alu
                          BR_PC_LD  <= '0';
                          BR_NOP_CU  <= '1';
                          s_br_nop_stall <= '0';
                          PS <= IDLE; 
                    when RET1 => 
                        s_ret_null_flag <= '1';
                        BR_NOP_CU <= '0';
                        PS <= RET2;
                    when RET2 => 
                        s_ret_null_flag <= '1';
                        BR_NOP_CU <= '0';
                        PS <= RET3;
                    when RET3 => 
--                        s_ret_null_flag <= '1';
                        BR_NOP_CU <= '0';
                        PS <= IDLE;
                    when RET4 => 
                        s_ret_null_flag <= '1';
                        BR_NOP_CU <= '0';
                        PS <= IDLE;
                    when RET5 => 
                        BR_NOP_CU <= '1';
                        PS <= IDLE;
                    when RET6 => 
                        BR_NOP_CU <= '1';
                        PS <= RET7;
                    when RET7 => 
                        BR_NOP_CU <= '1';
                        PS <= IDLE; 
                end case; 
                                
            end if;
                
        end process sync_process;



end Behavioral;
