--hps_alu
--EELE467 Final
--Michael Valentino-Manno
library IEEE;
use IEEE.STD_Logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity HPS_ALU is
    port(
            -- Interface with Avalon bus
            clk                    :     in std_logic;
            reset_n                 :     in std_logic; --reset asserted low
            avs_s1_address        :     in std_logic_vector(2 downto 0);
            avs_s1_write        :     in std_logic;
            avs_s1_writedata    :    in std_logic_vector(31 downto 0);
            avs_s1_read            :     in std_logic;
            avs_s1_readdata    :     out std_logic_vector(31 downto 0);
            switches                :     in std_logic_vector(3 downto 0);
            pushbutton            :     in std_logic;
            LEDs                    :     out std_logic_vector(7 downto 0)
            );
end HPS_ALU;

architecture HPS_ALU_arch of HPS_ALU is

	signal reg0 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0,32));
	signal reg1 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0,32));
	signal reg2 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0,32));
	signal reg3 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0,32));
	signal reg4 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0,32));
	signal reg5 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0,32));
	
	signal writ : std_logic;

	component ALU is
		port(
			clk	: in std_logic;
			reset : in std_logic;
			A	: in std_logic_vector(31 downto 0);
			B	: in std_logic_vector(31 downto 0);
			opcode	: in std_logic_vector(1 downto 0);
			write_en	: in std_logic;
			Res_High	: out std_logic_vector(31 downto 0);
			Res_Low	: out std_logic_vector(31 downto 0);
			stat	: out std_logic_vector(2 downto 0)
		);
	end component;
	
	component MUX is
		port(
			A : in std_logic_vector(31 downto 0);
			B : in std_logic_vector(31 downto 0);
			Res_High : in std_logic_vector(31 downto 0);
			Res_Low: in std_logic_vector(31 downto 0);
			SW : in std_logic_vector(3 downto 0);
			LED : out std_logic_vector(7 downto 0)
		);
	end component;
	
	begin
	
	READ_REG: process(clk) is  
		begin
			if(rising_edge(clk) and avs_s1_read ='1') then
				case(avs_s1_address) is
					when "000" => avs_s1_readdata <= reg0;
					when "001" => avs_s1_readdata <= reg1;
					when "010" => avs_s1_readdata <= reg2;
					when "011" => avs_s1_readdata <= reg3;
					when "100" => avs_s1_readdata <= reg4;
					when "101" => avs_s1_readdata <= reg5;
					when others => avs_s1_readdata <= (others =>'0'); --return zeros for undef regs
				end case;
			end if;
		end process;

	WRITE_REG : process(clk) is
		begin
			if(rising_edge(clk) and avs_s1_write = '1') then
				case(avs_s1_address) is
					when "000" => reg0 <= avs_s1_writedata;
										writ <= '0';
					when "001" => reg1 <= avs_s1_writedata;
										writ <= '0';
					when "010" => reg2 <= avs_s1_writedata;
										writ <= '1'; --opcode is changed, this is when we do operations
					when others => null;
				end case;
			end if;
		end process;
		
		
	ALU_1 : ALU port map(   --instantiate ALU and MUX
				clk => clk,
				reset => reset_n,
				A => reg0,
				B => reg1,
				opcode => reg2,
				write_en => writ,
				Res_High => reg4,
				Res_Low => reg3,
				stat => reg5(2 downto 0));
				
	MUX_1 : MUX port map(
				A => reg0,
				B => reg1,
				Res_High => reg4,
				Res_Low => reg3,
				SW => switches,
				LED => LEDs);
		
end architecture;