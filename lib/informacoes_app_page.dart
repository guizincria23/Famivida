import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InformacoesAppPage extends StatefulWidget {
  const InformacoesAppPage({super.key});

  @override
  State<InformacoesAppPage> createState() => _InformacoesAppPageState();
}

class _InformacoesAppPageState extends State<InformacoesAppPage> {
  String _periodoSelecionado = 'Últimos 6 meses';
  final List<String> _opcoesPeriodo = [
    'Últimos 30 dias',
    'Últimos 3 meses',
    'Últimos 6 meses',
    'Último ano',
    'Todo o histórico'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPainelSaude(),
            const SizedBox(height: 24),
            _buildRelatorios(),
            const SizedBox(height: 24),
            _buildExportacaoDados(),
            const SizedBox(height: 24),
            _buildSobreApp(),
          ],
        ),
      ),
    );
  }

  Widget _buildPainelSaude() {
    return Card(
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
                    xValueMapper: (DadosSaude dados, _) => dados.categoria,
                    yValueMapper: (DadosSaude dados, _) => dados.quantidade,
                    pointColorMapper: (DadosSaude dados, _) => dados.cor,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InfoItem(icone: Icons.people, titulo: 'Membros', valor: '4'),
                InfoItem(
                    icone: Icons.medical_services,
                    titulo: 'Consultas',
                    valor: '12'),
                InfoItem(icone: Icons.vaccines, titulo: 'Vacinas', valor: '8'),
                InfoItem(icone: Icons.assignment, titulo: 'Exames', valor: '5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatorios() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Relatórios de Saúde',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _periodoSelecionado,
              items: _opcoesPeriodo.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _periodoSelecionado = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Período do relatório',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTipoRelatorio('Consultas', Icons.medical_services),
                  _buildTipoRelatorio('Vacinas', Icons.vaccines),
                  _buildTipoRelatorio('Exames', Icons.assignment),
                  _buildTipoRelatorio('Medicamentos', Icons.medication),
                  _buildTipoRelatorio('Alergias', Icons.warning),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Gerar Relatório Completo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _gerarRelatorioCompleto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoRelatorio(String titulo, IconData icone) {
    return InkWell(
      onTap: () => _gerarRelatorio(titulo),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 40, color: Colors.teal),
            const SizedBox(height: 10),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildExportacaoDados() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exportação de Dados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Exporte todos os dados de saúde da família para backup ou compartilhamento com profissionais.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF'),
                    onPressed: _exportarParaPDF,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Excel'),
                    onPressed: _exportarParaExcel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              icon: const Icon(Icons.backup),
              label: const Text('Backup Completo'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _fazerBackupCompleto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSobreApp() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sobre o Aplicativo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.medical_services),
              title: Text('Saúde Familiar'),
              subtitle: Text('Versão 2.3.1'),
            ),
            const ListTile(
              leading: Icon(Icons.update),
              title: Text('Última atualização'),
              subtitle: Text('15/08/2023'),
            ),
            const ListTile(
              leading: Icon(Icons.security),
              title: Text('Política de Privacidade'),
              subtitle: Text('Seus dados estão protegidos'),
              trailing: Icon(Icons.chevron_right),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Este aplicativo foi desenvolvido para ajudar famílias a gerenciarem suas informações de saúde de forma centralizada e segura.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: _avaliarApp,
                child: const Text('Avalie nosso aplicativo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _gerarRelatorio(String tipo) {
    // Implementar geração de relatório específico
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Gerando relatório de $tipo para $_periodoSelecionado')),
    );
  }

  void _gerarRelatorioCompleto() {
    // Implementar geração de relatório completo
  }

  void _exportarParaPDF() {
    // Implementar exportação para PDF
  }

  void _exportarParaExcel() {
    // Implementar exportação para Excel
  }

  void _fazerBackupCompleto() {
    // Implementar backup completo
  }

  void _avaliarApp() {
    // Implementar redirecionamento para avaliação
  }
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
        Icon(icone, size: 30, color: Colors.teal),
        const SizedBox(height: 5),
        Text(titulo, style: const TextStyle(fontSize: 12)),
        Text(valor,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
