library ieee;
    use ieee.std_logic_1164.all;

entity multiplier is
    generic(
        Nbit : positive := 8
    );
    port (
        clk : in std_logic;
        reset   : in std_logic;
        en  : in std_logic;
        ow  : out std_logic;
        x : in std_logic_vector(Nbit - 1 downto 0);
        y : in std_logic_vector(Nbit - 1 downto 0);
        bout : out std_logic_vector(Nbit - 1 downto 0);
    );
end entity;

architecture struct of multiplier is
    component half_adder is
        port (
          a    : in  std_logic;
          b    : in  std_logic;
          s    : out std_logic;
          cout : out std_logic
        );
    end component;

    component full_adder is
        port (
          a    : in  std_logic;
          b    : in  std_logic;
          cin  : in  std_logic;
          s    : out std_logic;
          cout : out std_logic
        );
      end component;

    signal ha_result: std_logic_vector(Nbit - 2 downto 0);
    signal ha_cout: std_logic_vector(Nbit - 2 downto 0);

    signal fa0_result: std_logic_vector(Nbit - 2 downto 0);
    signal fa0_cout: std_logic_vector(Nbit - 2 downto 0);

    type faMatrix is array(0 to Nbit - 4) of std_logic_vector(Nbit - 2 downto 0);
    signal fa_result: faMatrix;
    signal fa_cout: faMatrix;
    
    signal result : std_logic_vector(Nbit - 1 downto 0);

    signal cout_last : std_logic_vector(Nbit -2 downto 0);
begin

    -- first row, half adder
    for j in 0 to Nbit - 2 loop
        HA_i: half_adder 
        port map (
          a    =>   (x(j) and y(0)),
          b    =>   (x(j) and y(1)),
          s    =>   ha_result(j),
          cout =>   ha_cout(j)
        );
    end loop;

    -- secondo row, first full adder, last one has different A input value
    for j in 0 to Nbit - 2 loop
        if j = Nbit - 2 then
            FA_i0: full_adder 
                port map (
                a    =>   (x(Nbit - 1) and y(1)),
                b    =>   (x(j) and y(2)),
                cin  =>   ha_cout(j),
                s    =>   fa0_result(j),
                cout =>   fa0_cout(j)
            );
        else
            FA_i0: full_adder 
            port map (
                a    =>   ha_result(j+1),
                b    =>   (x(j) and y(2)),
                cin  =>   ha_cout(j),
                s    =>   fa0_result(j),
                cout =>   fa0_cout(j)
            );
        end if;
    end loop;

    -- 3 to N-1 row, full adder
    
    for i in 3 to Nbit - 1 loop
        for j in 0 to Nbit - 2 loop
            if j = Nbit - 2 then
                FA_i: full_adder 
                    port map (
                    a    =>   (x(Nbit - 1) and y(i-1)),
                    b    =>   (x(j) and y(i)),
                    cin  =>   fa0_cout(j),
                    s    =>   fa_result(i)(j),
                    cout =>   fa_cout(i)(j)
                );
            else
                if i = 3 then
                    FA_i: full_adder 
                        port map (
                        a    =>   fa0_result(j+1),
                        b    =>   (x(j) and y(i)),
                        cin  =>   fa0_cout(j),
                        s    =>   fa_result(i)(j),
                        cout =>   fa_cout(i)(j)
                    );
                else
                    FA_i: full_adder 
                    port map (
                        a    =>   fa_result(i-1)(j),
                        b    =>   (x(j) and y(i)),
                        cin  =>   fa_cout(i-1)(j),
                        s    =>   fa_result(i)(j),
                        cout =>   fa_cout(i)(j)
                    );
                end if;
            end if;
        end loop;
    end loop;

    -- last row, Full Adder + Half adder
    HA_last: half_adder 
    port map (
      a    =>   fa_result(Nbit - 1)(1),
      b    =>   fa_cout(Nbit - 1)(0),
      s    =>   open,
      cout =>   cout_last(0)
    );
    
    -- last full adders are omitted because our output has Nbit dimension

    result(0) <= (x(0) and y(0));
    result(1) <= ha_result(0);
    result(2) <= fa0_result(0);

    for i 3 to Nbit-1 loop
        result(i) <= fa_result(0);
    end loop;
end architecture;
