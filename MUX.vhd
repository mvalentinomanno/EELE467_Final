--MUX
--EELE467 Final
--Michael Valentino-Manno

library IEEE;
use IEEE.STD_Logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity MUX is
	port(
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Res_High : in std_logic_vector(31 downto 0);
		Res_Low: in std_logic_vector(31 downto 0);
		SW : in std_logic_vector(3 downto 0);
		LED : out std_logic_vector(7 downto 0)
		);
end entity;

architecture MUX_arch of MUX is
	--signal to represent the current register selected by the switches
	signal cur_reg : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0,32));
	
	begin
	
	REG_SEL : process(SW)
		begin
			case(SW(3 downto 2)) is  --selects 2 bit value to display
				when "00" => cur_reg <= A;
				when "01" => cur_reg <= B;
				when "10" => cur_reg <= Res_Low;
				when "11" => cur_reg <= Res_High;
				when others => cur_reg <= (others =>'0');
			end case;
		end process;
		
	DISP_SEL : process(SW)  --select the byte to display
		begin
			case(SW(1 downto 0)) is
				when "00" => LED <= cur_reg(7 downto 0);
				when "01" => LED <= cur_reg(15 downto 8);
				when "10" => LED <= cur_reg(23 downto 16);
				when "11" => LED <= cur_reg(31 downto 24);
				when others => LED <= (others => '0');
			end case;
		end process;
		
end architecture;