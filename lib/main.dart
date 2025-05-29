import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'agendamento_lembretes.dart';
import 'teleconsultas_page.dart';
import 'historico_medico_page.dart';
import 'seguranca_privacidade_page.dart';
import 'informacoes_app_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(const AppSaudeFamiliar());

class AppSaudeFamiliar extends StatelessWidget {
  const AppSaudeFamiliar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FamiVida',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _indiceAtual = 0;

  final List<Map<String, dynamic>> _menuItens = [
    {'titulo': 'FamiVida', 'icone': Icons.dashboard, 'cor': Colors.teal},
    {
      'titulo': 'Agendamentos',
      'icone': Icons.calendar_today,
      'cor': Colors.teal
    },
    {
      'titulo': 'Consultas',
      'icone': Icons.medical_services,
      'cor': Colors.teal
    },
    {'titulo': 'Histórico', 'icone': Icons.history, 'cor': Colors.teal},
    {'titulo': 'Configurações', 'icone': Icons.settings, 'cor': Colors.teal},
    {'titulo': 'Informações', 'icone': Icons.info, 'cor': Colors.teal},
  ];

  final List<MembroFamiliar> _membros = [
    MembroFamiliar(
      nome: 'Maria Silva',
      idade: 32,
      parentesco: 'Mãe',
      foto: '👩',
      vacinas: [
        Vacina(nome: 'COVID-19', data: DateTime(2023, 5, 10)),
        Vacina(nome: 'Gripe', data: DateTime(2023, 4, 15)),
      ],
    ),
    MembroFamiliar(
      nome: 'João Silva',
      idade: 8,
      parentesco: 'Filho',
      foto: '👦',
      vacinas: [
        Vacina(nome: 'Sarampo', data: DateTime(2023, 3, 20)),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_menuItens[_indiceAtual]['titulo']),
        backgroundColor: _menuItens[_indiceAtual]['cor'],
      ),
      body: _buildPaginaAtual(),
      drawer: _buildMenuLateral(),
    );
  }

  Widget _buildMenuLateral() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFFA89BEC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.family_restroom, size: 40),
                ),
                SizedBox(height: 10),
                Text('FamiVida',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
          ..._menuItens.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return ListTile(
              leading: Icon(item['icone'], color: item['cor']),
              title: Text(item['titulo']),
              selected: _indiceAtual == index,
              selectedTileColor: item['cor'].withOpacity(0.1),
              onTap: () {
                setState(() => _indiceAtual = index);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaginaAtual() {
    switch (_indiceAtual) {
      case 0:
        return _buildDashboard();
      case 1:
        return const AgendamentosPage();
      case 2:
        return const TeleconsultasPage();
      case 3:
        return const HistoricoMedicoPage();
      case 4:
        return const SegurancaPrivacidadePage();
      case 5:
        return const InformacoesAppPage();
      default:
        return Container();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Painel de Saúde da Família (novo)
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Painel de Saúde da Família',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        ColumnSeries<DadosSaude, String>(
                          dataSource: [
                            DadosSaude('Consultas', 12, Colors.blue),
                            DadosSaude('Vacinas', 8, Colors.green),
                            DadosSaude('Exames', 5, Colors.orange),
                            DadosSaude('Emergências', 2, Colors.red),
                          ],
                          xValueMapper: (DadosSaude dados, _) =>
                              dados.categoria,
                          yValueMapper: (DadosSaude dados, _) =>
                              dados.quantidade,
                          pointColorMapper: (DadosSaude dados, _) => dados.cor,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InfoItem(
                          icone: Icons.people, titulo: 'Membros', valor: '2'),
                      InfoItem(
                          icone: Icons.medical_services,
                          titulo: 'Consultas',
                          valor: '12'),
                      InfoItem(
                          icone: Icons.vaccines, titulo: 'Vacinas', valor: '8'),
                      InfoItem(
                          icone: Icons.assignment,
                          titulo: 'Exames',
                          valor: '5'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Minha Família (existente)
          const Text('Minha Família',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            children: _membros
                .map((membro) => Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.blue.shade50,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => _mostrarDetalhesMembro(membro),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(membro.foto,
                                  style: const TextStyle(fontSize: 40)),
                              const SizedBox(height: 8),
                              Text(membro.nome,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text('${membro.idade} anos'),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 24),
          const Text('Próximas Consultas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.medical_services, color: Colors.green),
                    title: Text('Pediatra - Dr. Carlos'),
                    subtitle: Text('15/06/2023 - 14:30'),
                    trailing: Icon(Icons.notifications_active),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.medical_services, color: Colors.blue),
                    title: Text('Clínico Geral - Dra. Ana'),
                    subtitle: Text('20/06/2023 - 09:15'),
                    trailing: Icon(Icons.notifications_none),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhesMembro(MembroFamiliar membro) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(membro.foto, style: const TextStyle(fontSize: 50)),
            Text(membro.nome,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('${membro.idade} anos • ${membro.parentesco}'),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Vacinas',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...membro.vacinas.map((v) => ListTile(
                  leading:
                      const Icon(Icons.medical_services, color: Colors.green),
                  title: Text(v.nome),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(v.data)),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Fechar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class MembroFamiliar {
  final String nome;
  final int idade;
  final String parentesco;
  final String foto;
  final List<Vacina> vacinas;

  MembroFamiliar({
    required this.nome,
    required this.idade,
    required this.parentesco,
    required this.foto,
    required this.vacinas,
  });
}

class Vacina {
  final String nome;
  final DateTime data;

  Vacina({
    required this.nome,
    required this.data,
  });
}

class DadosSaude {
  final String categoria;
  final int quantidade;
  final Color cor;

  DadosSaude(this.categoria, this.quantidade, this.cor);
}

class InfoItem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const InfoItem({
    super.key,
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icone, size: 30, color: Colors.purple),
        const SizedBox(height: 5),
        Text(titulo, style: const TextStyle(fontSize: 12)),
        Text(valor,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
