import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Collector;

public class Main {

    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        String[] input = scanner.nextLine().split(" ");
        scanner.close();

        int n1 = Integer.parseInt(input[0]);
        int n2 = Integer.parseInt(input[1]);
        int n3 = Integer.parseInt(input[2]);
        int n4 = Integer.parseInt(input[3]);
        
        List<CountryRecord> records = Files.readAllLines(Paths.get("dados.csv"))
        .stream()
        .map(Main::parseCsvRecord)
        .collect(Collectors.toList());
        
        System.out.println(operation1(n1, records));
        System.out.println(operation2(n2, n3, records));
        System.out.println(operation3(n4, records));
    }

    static class CountryRecord {
        private final String country;
        private final int confirmed;
        private final int deaths;
        private final int recovery;
        private final int active;

        CountryRecord(String country, int confirmed, int deaths, int recovery, int active) {
            this.country = country;
            this.confirmed = confirmed;
            this.deaths = deaths;
            this.recovery = recovery;
            this.active = active;
        }


        // getters para os atributos
        String getCountry() {
            return country;
        }

        int getConfirmed() {
            return confirmed;
        }

        int getDeaths() {
            return deaths;
        }

        int getRecovery() {
            return recovery;
        }

        int getActive() {
            return active;
        }
    }

    // parse que le o arquivo csv como nosso dado de país
    static CountryRecord parseCsvRecord(String line) {
        String[] parts = line.split(",");
        return new CountryRecord(parts[0], Integer.parseInt(parts[1]), Integer.parseInt(parts[2]), Integer.parseInt(parts[3]), Integer.parseInt(parts[4]));
    }

    static int operation1(int n1, List<CountryRecord> records) {
        return records.stream()
                .filter(record -> record.getConfirmed() >= n1)  // filtra apenas os países com confirme >= n1
                .mapToInt(record -> record.getActive())         // pega uma nova lista de inteiros com os avtives
                .sum();                                         // soma os inteiros da lista
    }

    static int operation2(int n2, int n3, List<CountryRecord> records) {
        return records.stream()
                .sorted(Comparator.comparingInt( record -> -record.getActive()))    // multiplicando por -1 para ordenar os active do maior para o menor
                .limit(n2)                                                          // pegando apenas os n2 maiores active
                .sorted(Comparator.comparingInt(record -> record.getConfirmed()))   // ordenando pelos confirmed do menor para o maior
                .limit(n3)                                                          // pegando os n3 menores confirmed
                .mapToInt(record -> record.getDeaths())                             // pegando as mortes como uma lista de inteiros
                .sum();                                                             // somando as mortes
    }

    static String operation3(int n4, List<CountryRecord> records) {
        return records.stream()
                .sorted(Comparator.comparingInt( record -> -record.getConfirmed()))  // ordenando pelos confirmed do maior para o menor
                .limit(n4)                                                           // pegando os n4 maiores confirmed
                .sorted(Comparator.comparing( record -> record.getCountry()))        // ordenando por ordem alfabética
                .map(record -> record.getCountry())                                  // pegando uma nova lista com os países
                .collect(Collectors.joining("\n"));                        // agregando os países com o \n no final
    }
}