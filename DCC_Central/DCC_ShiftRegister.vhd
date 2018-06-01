----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2018 04:32:50 PM
-- Design Name: 
-- Module Name: DCC_ShiftRegister - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DCC_ShiftRegister is
    Port ( Clk_100Mhz : in STD_LOGIC;
           Reset : in std_logic;
           DCC_Param_1 : in STD_LOGIC_VECTOR (31 downto 0);
           DCC_Param_2 : in STD_LOGIC_VECTOR (31 downto 0);
           DCC_Control : in STD_LOGIC_VECTOR (31 downto 0);
           Fin_Trame : out std_logic;
           Com_Reg : in std_logic;
           DCC_Bit : out STD_LOGIC);
end DCC_ShiftRegister;

architecture Behavioral of DCC_ShiftRegister is
attribute KEEP : string;
signal Trame_reg : std_logic_vector (63 downto 0);
signal Shift_Trame_reg : std_logic_vector (63 downto 0);
attribute KEEP of Trame_reg : signal is "true";
signal Trame_cpt : integer range 0 to 63;
signal Fin_Trame_reg : std_logic;
signal Trame_fin_cpt : integer range 0 to 63;
attribute KEEP of Trame_fin_cpt : signal is "true";
signal DCC_Param_1_reg : std_logic_vector (31 downto 0);
signal DCC_Param_2_reg : std_logic_vector (31 downto 0);
signal DCC_Control_reg : std_logic_vector (31 downto 0);
attribute KEEP of DCC_Param_1_reg : signal is "true";
attribute KEEP of DCC_Param_2_reg : signal is "true";
attribute KEEP of DCC_Control_reg : signal is "true";
begin
    DCC_Param_1_reg <= DCC_Param_1;
    DCC_Param_2_reg <= DCC_Param_2;
    DCC_Control_reg <= DCC_Control;
    DCC_bit <= Shift_Trame_reg (63);
    Fin_Trame <= Fin_Trame_reg;
    clocked : process (Reset, Clk_100MHz, DCC_Param_1, DCC_Param_2, DCC_Control, Com_Reg)
    begin
        if Reset = '1' then
            Trame_reg <= x"0000000000000000";
            Shift_Trame_reg <= x"0000000000000000";
            Trame_cpt <= 63;
            Trame_fin_cpt <= 0;
            Fin_Trame_reg <= '0';
        elsif rising_edge (Clk_100MHz) then
            if DCC_Control_reg (0) = '1' then
                Trame_reg (63 downto 50) <= b"11111111111111";
                Trame_reg (49) <= '0';
                Trame_reg (48 downto 41) <= DCC_Param_1_reg (7 downto 0);
                Trame_reg (40) <= '0';
                
               if DCC_param_2_reg (15 downto 14) = "11" then 
                    Trame_reg (39 downto 32) <= DCC_Param_2_reg (15 downto 8);
                    Trame_reg (31) <= '0';
                    Trame_reg (30 downto 23) <= DCC_Param_2_reg (7 downto 0);
                    Trame_reg (22) <= '0';
                    Trame_reg (21 downto 14) <= DCC_Param_1_reg (7 downto 0) xor DCC_Param_2_reg (15 downto 8) xor DCC_Param_2_reg (7 downto 0);
                    Trame_reg (13) <= '1';
                    Trame_fin_cpt <= 13;
               else 
                    Trame_reg (39 downto 32) <= DCC_Param_2_reg (15 downto 8);
                    Trame_reg (31) <= '0'; 
                    Trame_reg (30 downto 23) <= DCC_Param_1_reg (7 downto 0) xor DCC_Param_2_reg (15 downto 8); 
                    Trame_reg (22) <= '1';  
                    Trame_fin_cpt <= 22;          
               end if;
           else
               Trame_reg <= Trame_reg;    
           end if;
                
            if Com_Reg = '1' then
                if Trame_Cpt = Trame_fin_cpt then
                    Trame_cpt <= 63;
                    Shift_Trame_reg <= Trame_reg;
                    Fin_Trame_reg <= '1';
                else
                    Shift_Trame_reg <= Shift_Trame_reg (62 downto 0) & "0";
                    Trame_cpt <= Trame_cpt - 1;
                    Fin_Trame_reg <= '0';
                end if;
            end if;
        end if;
    end process clocked;
end Behavioral;
