library IEEE;
 use IEEE.std_logic_1164.all;

entity counter is
 generic (
    Nbit : positive := 8
 );
 port (
    clk : in std_logic;
    rst : in std_logic;
    en  : in std_logic;
    sin : in std_logic_vector(Nbit - 1 downto 0);
    sout : out std_logic_vector(Nbit - 1 downto 0)
 );
end entity;

architecture beh of counter is
    component flip_flop is
        generic (
          Nbit : positive := 8
        );
        port (
          clk   : in std_logic;
          resetn: in std_logic;
          en    : in std_logic;
          di    : in std_logic_vector(Nbit - 1 downto 0);
          do    : out std_logic_vector(Nbit - 1 downto 0)
        );
    end component;

    component ripple_carry_adder is
        generic (
          Nbit : positive := 8
        );
        port (
          a    : in  std_logic_vector(Nbit - 1 downto 0);
          b    : in  std_logic_vector(Nbit - 1 downto 0);
          cin  : in  std_logic;
          s    : out std_logic_vector(Nbit - 1 downto 0);
          cout : out std_logic
        );
    end component;

    signal dff_in : std_logic_vector(Nbit - 1 downto 0);
    signal dff_out : std_logic_vector(Nbit - 1 downto 0);

begin
    RCA : ripple_carry_adder
        generic map(
            Nbit => Nbit
        )
        port map(
            a => sin,
            b => dff_in,
            cin => '0',
            s => dff_in,
            cout => open
        );

    FF : flip_flop 
        generic map(
            Nbit => Nbit
        )
        port map(
            clk => clk,
            resetn => rst,
            en => en,
            di => dff_out,
            do => dff_in
        );

    sout <= dff_in;

end architecture;