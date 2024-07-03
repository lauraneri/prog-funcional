import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

public class Main {

    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        String[] input = scanner.nextLine().split(" ");
        int n1 = Integer.parseInt(input[0]);
        int n2 = Integer.parseInt(input[1]);
        int n3 = Integer.parseInt(input[2]);
        int n4 = Integer.parseInt(input[3]);

        List<String> lines = Files.readAllLines(Paths.get("dados.csv"));
        List<CountryRecord> records = new ArrayList<>();

        // preenche lista dos records depois de parsear as linhas do csv
        for (String line : lines) {
            records.add(parseCsvRecord(line));
        }

        System.out.println(operation1(n1, records));
        System.out.println(operation2(n2, n3, records));
        System.out.print(operation3(n4, records));
        scanner.close();
    }

    static class CountryRecord {
        String country;
        int confirmed;
        int deaths;
        int recovery;
        int active;

        CountryRecord(String country, int confirmed, int deaths, int recovery, int active) {
            this.country = country;
            this.confirmed = confirmed;
            this.deaths = deaths;
            this.recovery = recovery;
            this.active = active;
        }
    }

    static CountryRecord parseCsvRecord(String line) {
        String[] parts = line.split(",");
        return new CountryRecord(parts[0], Integer.parseInt(parts[1]), Integer.parseInt(parts[2]), Integer.parseInt(parts[3]), Integer.parseInt(parts[4]));
    }

    static int operation1(int n1, List<CountryRecord> records) {
        int sum = 0;
        for (CountryRecord record : records) {
            if (record.confirmed >= n1) {
                sum += record.active; // Soma os actives onde os casos confirmados são >= n1
            }
        }
        return sum;
    }

    static int operation2(int n2, int n3, List<CountryRecord> records) {
        // Ordena os registros por actives em ordem decrescente
        Collections.sort(records, new Comparator<CountryRecord>() {
            public int compare(CountryRecord r1, CountryRecord r2) {
                return Integer.compare(r2.active, r1.active);
            }
        });

        // Obtém os n2 registros com os actives mais altos
        List<CountryRecord> topActiveRecords = records.subList(0, n2);

        // Ordena esses n2 registros por casos confirmados em ordem crescente
        Collections.sort(topActiveRecords, new Comparator<CountryRecord>() {
            public int compare(CountryRecord r1, CountryRecord r2) {
                return Integer.compare(r1.confirmed, r2.confirmed);
            }
        });

        // Soma as deaths dos n3 registros com os confirmed mais baixos
        int sum = 0;
        for (int i = 0; i < Math.min(n3, topActiveRecords.size()); i++) {
            sum += topActiveRecords.get(i).deaths;
        }
        return sum;
    }

    static String operation3(int n4, List<CountryRecord> records) {
        // Ordena os registros por confirmed em ordem decrescente
        Collections.sort(records, new Comparator<CountryRecord>() {
            public int compare(CountryRecord r1, CountryRecord r2) {
                return Integer.compare(r2.confirmed, r1.confirmed);
            }
        });

        // Obtém os n4 registros com os confirmed mais altos
        List<CountryRecord> topConfirmedRecords = records.subList(0, Math.min(n4, records.size()));

        // nova lista com nome dos países
        List<String> countryNames = new ArrayList<>();
        for (CountryRecord record : topConfirmedRecords) {
            countryNames.add(record.country);
        }

        // Ordena os nomes dos países em ordem alfabética
        Collections.sort(countryNames);

        // Junta os nomes dos países com \n
        StringBuilder result = new StringBuilder();
        for (String name : countryNames) {
            result.append(name).append("\n");
        }
        return result.toString();
    }
}
