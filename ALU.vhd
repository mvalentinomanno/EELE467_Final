--ALU
--EELE467 Final
--Michael Valentino-Manno
library IEEE;
use IEEE.STD_Logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity ALU is
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
end entity;

architecture ALU_arch of ALU is
			--define states to be used in machine
	type State_Type is (S0, S1, S2, S3);
	--define signals to be assigned
	signal current_state, next_state : State_Type;
	signal res_h0, res_h1, res_h2, res_h3 : std_logic_vector(31 downto 0);
	signal res_l0, res_l1, res_l2, res_l3 : std_logic_vector(31 downto 0);
	signal stat0, stat1, stat2, stat3 : std_logic_vector(2 downto 0); 

	--define the states
	component st3 is
		port(clk : in std_logic;
		reset : in std_logic;
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Res_High : out std_logic_vector(31 downto 0);
		Res_Low : out std_logic_vector(31 downto 0);
		stat : out std_logic_vector(2 downto 0));
	end component;
	
	
	component st2 is
		port(clk : in std_logic;
		reset : in std_logic;
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Res_High : out std_logic_vector(31 downto 0);
		Res_Low : out std_logic_vector(31 downto 0);
		stat : out std_logic_vector(2 downto 0));
	end component;
	
	
	component st1 is
		port(clk : in std_logic;
		reset : in std_logic;
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Res_High : out std_logic_vector(31 downto 0);
		Res_Low : out std_logic_vector(31 downto 0);
		stat : out std_logic_vector(2 downto 0));
	end component;
	
	
	component st0 is
		port(clk : in std_logic;
		reset : in std_logic;
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Res_High : out std_logic_vector(31 downto 0);
		Res_Low : out std_logic_vector(31 downto 0);
		stat : out std_logic_vector(2 downto 0));
	end component;
	
	
	
	begin
	--instantiate the different states
	ST_3 : st3 port map(clk => clk, reset => reset, A => A, B => B, Res_High => res_h3, Res_Low => res_l3, stat => stat3);
	ST_2 : st2 port map(clk => clk, reset => reset, A => A, B => B, Res_High => res_h2, Res_Low => res_l2, stat => stat2);
	ST_1 : st1 port map(clk => clk, reset => reset, A => A, B => B, Res_High => res_h1, Res_Low => res_l1, stat => stat1);
	ST_0 : st0 port map(clk => clk, reset => reset, A => A, B => B, Res_High => res_h0, Res_Low => res_l0, stat => stat0);
	
			--state machine beginning
		STATE_MEMORY : process(clk,reset)
			begin
				if(reset ='0') then
					current_state <= current_state;
				elsif(rising_edge(clk)) then
					current_state <= next_state;
				end if;
			end process;
			
			
		STATE_LOGIC : process(current_state)
			begin
				case(opcode) is
					when "00" => next_state <= S0; --a+b
					when "01" => next_state <= S1;  --a-b
					when "10" => next_state <= S2;  --a*b
					when "11" => next_State <= S3;  --a&b
					when others => next_state <= current_state;
				end case;
			end process;
		
		OUTPUT_LOGIC : process (current_state)
			begin
				if(write_en = '1') then     --only execute if an op code is written
					case(current_state) is
						when S0 =>           --a+b
							Res_High <= res_h0;
							Res_Low <= res_l0;
							stat <= stat0;
						when S1 =>             --a-b
							Res_High <= res_h1;
							Res_Low <= res_l1;
							stat <= stat1;							
						when S2 =>             --a*b
							Res_High <= res_h2;
							Res_Low <= res_l2;
							stat <= stat2;		
						when S3 =>              --a & b
							Res_High <= res_h3;
							Res_Low <= res_l3;
							stat <= stat3;
						when others =>
							Res_High <= std_logic_vector(to_unsigned(0,32));
							Res_Low <= std_logic_vector(to_unsigned(0,32));
							stat <= std_logic_vector(to_unsigned(0,3));
						end case;
					end if;
				end process;
end architecture;