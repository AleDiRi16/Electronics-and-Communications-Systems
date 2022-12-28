library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity multiplier_tb is
end multiplier_tb;

architecture beh of multiplier_tb is
    constant clk_period : time := 100 ns;
    constant N          : positive := 8;
<<<<<<< Updated upstream
    constant T_RESET : time := 250 ns;
=======
>>>>>>> Stashed changes

    component multiplier is
        generic(
            Nbit : positive := 8
        );
        port (
            clk : in std_logic;
            reset   : in std_logic;
            en  : in std_logic;
<<<<<<< Updated upstream
=======
            ow  : out std_logic;
>>>>>>> Stashed changes
            x : in std_logic_vector(Nbit - 1 downto 0);
            y : in std_logic_vector(Nbit - 1 downto 0);
            bout : out std_logic_vector(Nbit - 1 downto 0)
        );
    end component;
    
    signal clk : std_logic := '0';
    signal reset_ext   : std_logic := '0';
    signal en_ext : std_logic := '0';
    signal x_ext : std_logic_vector(N - 1 downto 0) := (others => '0');
    signal y_ext : std_logic_vector(N - 1 downto 0) := (others => '0');
    signal bout_ext : std_logic_vector(N - 1 downto 0);
<<<<<<< Updated upstream
=======
    signal ow_ext  : std_logic;
>>>>>>> Stashed changes
    signal testing  : boolean := true;

begin

    clk <= not clk after clk_period/2 when testing else '0';
<<<<<<< Updated upstream
    reset_ext <= '1' after T_RESET;
=======
>>>>>>> Stashed changes

    MUL: multiplier
        generic map(
            Nbit => N
        )
        port map (
            clk => clk,
            reset => reset_ext,
            en => en_ext,
<<<<<<< Updated upstream
=======
            ow => ow_ext,
>>>>>>> Stashed changes
            x => x_ext,
            y => y_ext,
            bout => bout_ext
        );

<<<<<<< Updated upstream
    STIMULI : process(clk,reset_ext) 
        variable t : integer := 0;
        begin
       if reset_ext = '0' then
        --reset_ext <= '0';
        en_ext <= '0';
        x_ext <= (others => '0');
        y_ext <= (others => '0');
        t := 0; 
        elsif rising_edge(clk) then
        case t is
            when 0 =>
--        wait for 200 ns;
        x_ext <= "00000111";
        y_ext <= "00000111";
            when 25 => testing <= false;
            when others =>
        end case;
        t := t+1;
        end if;
=======
    STIMULI : process begin
        reset_ext <= '0';
        en_ext <= '0';
        x_ext <= (others => '0');
        y_ext <= (others => '0');

        wait for 200 ns;
        x_ext <= "00000110";
        y_ext <= "00000110";

        wait until rising_edge(clk);
        x_ext <= "00000001";
        y_ext <= "00000001";
        
        wait until rising_edge(clk);
        x_ext <= "00001000";
        y_ext <= "00001110";
        
        wait for 500  ns;
        testing <= false;
>>>>>>> Stashed changes
    end process;

end architecture;