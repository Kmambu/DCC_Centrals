----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2018 01:33:28 PM
-- Design Name: 
-- Module Name: DCC_Central - Behavioral
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

entity DCC_Central is
Port (  Clk_100MHz : in std_logic;
        Reset : in std_logic;
        Button_L : in std_logic;
        Button_R : in std_logic;
        Button_C : in std_logic;
        Sw : in std_logic_vector (11 downto 0);
        DCC_Out : out std_logic);
end DCC_Central;

architecture Behavioral of DCC_Central is
    signal Clk_1MHz : std_logic;
    signal DCC_Param_1 : std_logic_vector (31 downto 0);
    signal DCC_Param_2 : std_logic_vector (31 downto 0);
    signal DCC_Control : std_logic_vector (31 downto 0);
    signal Fin_Tempo : std_logic;
    signal Com_Reg : std_logic;
    signal Fin_Trame : std_logic;
    signal Com_Tempo : std_logic;
    signal DCC_Bit : std_logic;
    signal GO_0 : std_logic;
    signal FIN_0 : std_logic;
    signal DCC_0 : std_logic;
    signal GO_1 : std_logic;
    signal FIN_1 : std_logic;
    signal DCC_1 : std_logic;
begin
    U1 : entity work.DCC_TrameGen
    port map(   Clk_100MHz => Clk_100MHz,
                Reset => Reset,
                Button_L => Button_L,
                Button_R => Button_R,
                Button_C => Button_C,
                Sw => Sw,
                DCC_Param_1 => DCC_Param_1,
                DCC_Param_2 => DCC_Param_2,

                DCC_Control => DCC_Control);
    U2 : entity work.Clock_Divider
    port map(   Clk_100MHz => Clk_100MHz,
                Clk_1MHz => Clk_1MHz,
                Reset => Reset);
    U3 : entity work.DCC_ShiftRegister
    port map(   Reset => Reset,
                Clk_100MHz => Clk_100MHz,
                DCC_Param_1 => DCC_Param_1,
                DCC_Param_2 => DCC_Param_2,
                DCC_Control => DCC_Control,
                Fin_Trame => Fin_Trame,
                Com_Reg => Com_Reg,
                DCC_Bit => DCC_Bit);
    U4 : entity work.DCC_Bit_0
    port map(   GO_0 => GO_0,
                FIN_0 => FIN_0,
                DCC_0 => DCC_0,
                Clk_1MHz => Clk_1MHz,
                Clk_100MHz => Clk_100MHz,
                Reset => Reset);
    U5 : entity work.DCC_Bit_1
    port map(   GO_1 => GO_1,
                FIN_1 => FIN_1,
                DCC_1 => DCC_1,
                Clk_1MHz => Clk_1MHz,
                Clk_100MHz => Clk_100MHz,
                Reset => Reset);
    U6 : entity work.MAE
    port map(   Clk_100MHz => Clk_100MHz,
                Reset => Reset,
                DCC_Bit => DCC_Bit,
                FIN_1 => FIN_1,
                FIN_0 => FIN_0,
                Fin_Trame => Fin_Trame,
                Fin_Tempo => Fin_Tempo,
                Com_Reg => Com_Reg,
                Com_Tempo => Com_Tempo,
                GO_1 => GO_1,
                GO_0 => GO_0);
    U7 : entity work.Tempo
    port map(   Clk_1MHz => Clk_1MHz,
                Reset => Reset,
                Com_Tempo => Com_Tempo,
                Fin_Tempo => Fin_Tempo);
    DCC_Out <= DCC_0 or DCC_1;
end Behavioral;
