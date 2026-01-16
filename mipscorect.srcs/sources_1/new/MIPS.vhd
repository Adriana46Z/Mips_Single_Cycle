----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2025 08:36:26 PM
-- Design Name: 
-- Module Name: mips - Behavioral
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

entity MIPS is
    Port ( btn : in STD_LOGIC_VECTOR(4 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an  : out STD_LOGIC_VECTOR (7 downto 0));
end mips;

architecture Behavioral of MIPS is

signal en: std_logic;
signal cnt: std_logic_vector (4 downto 0):= "00000";
signal do: std_logic_vector(31 downto 0):= x"00000000";

component MPG 
   port(btn:in std_logic;
        clk:in std_logic;
        en:out std_logic);
end component;

component SSD
   port(clk: in std_logic;
        digits: in std_logic_vector(31 downto 0);
        an: out std_logic_vector(7 downto 0);
        cat: out std_logic_vector(6 downto 0));
end component;

type memory is array (0 to 31) of std_logic_vector(31 downto 0);
signal mem: memory :=(
B"001000_00000_00010_0000000000000001", -- 0000:ADDI $2, $0, 1 Initializeaza R2 cu 1
B"001000_00000_00011_0000000000000011", -- 0001:ADDI $3, $0, 3 Initializeaza R3 cu 3
B"001000_00000_00100_0000000000000000", -- 0010: ADDI $4, $0, 0 Initializeaza R4 cu 0
B"101011_00010_00011_0000000000000100", -- 0011:SW $3, 4($2) Salveaza in memorie la adresa 5, continutul lui R3=3
B"100011_00010_00100_0000000000000100", -- 0100:LW $4, 4($2) Salveaza de la adresa 5 din memorie, in R4,
                                        -- valoarea 3, stocata anterior
B"000100_00011_00100_0000000000000001", --0110: BEQ $3, $4, 1 Verifica daca registrele R3 si R4 au valori egale
                                        --daca da, se sare o instructiune peste cea de dupa BEQ (ADD)
B"000010_00000000000000000000000010",   --0111: J 2 Se face salt la adresa absoluta 2    al 3 lea ADDI
B"000000_00011_00010_00100_00000_100000", --1000: ADD $4, $3, $2 In R4 se adauga suma reg. R3 si R2 R4=3+1
others => X"00000000");

begin
c1: MPG port map(btn(0), clk, en);
c2: SSD port map (clk, do, an, cat);

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            cnt <= cnt + 1;
        end if;
    end if;
end process;

do<=mem(conv_integer(cnt));

end Behavioral;
