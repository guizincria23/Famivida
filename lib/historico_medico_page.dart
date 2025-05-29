import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoricoMedicoPage extends StatefulWidget {
  const HistoricoMedicoPage({super.key});

  @override
  State<HistoricoMedicoPage> createState() => _HistoricoMedicoPageState();
}

class _HistoricoMedicoPageState extends State<HistoricoMedicoPage> {
  int _membroSelecionado = 0;
  final List<Membro> _membros = [
    Membro(
      nome: 'Maria Silva',
      foto: '👩',
      eventos: [
        Evento(
          tipo: 'Vacina',
          titulo: 'COVID-19 - Dose 3',
          data: DateTime(2023, 5, 10),
          descricao: 'Vacina aplicada no posto central',
          lembrete: DateTime(2024, 5, 10),
          documentos: [],
        ),
        Evento(
          tipo: 'Alergia',
          titulo: 'Alergia a Penicilina',
          data: DateTime(2022, 3, 15),
          descricao: 'Reação alérgica grave detectada',
          documentos: [],
        ),
        Evento(
          tipo: 'Consulta',
          titulo: 'Clínico Geral - Dr. Carlos',
          data: DateTime(2023, 6, 15),
          descricao: 'Check-up anual',
          documentos: [
            Documento(nome: 'Receita Médica', tipo: 'PDF'),
            Documento(nome: 'Exame de Sangue', tipo: 'PDF'),
          ],
        ),
      ],
    ),
    Membro(
      nome: 'João Silva',
      foto: '👦',
      eventos: [
        Evento(
          tipo: 'Vacina',
          titulo: 'Sarampo - Reforço',
          data: DateTime(2023, 3, 20),
          descricao: 'Vacina aplicada na escola',
          lembrete: DateTime(2028, 3, 20),
          documentos: [],
        ),
        Evento(
          tipo: 'Condição Crônica',
          titulo: 'Asma',
          data: DateTime(2021, 8, 10),
          descricao: 'Diagnóstico confirmado por pneumologista',
          documentos: [
            Documento(nome: 'Laudo Médico', tipo: 'PDF'),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final membro = _membros[_membroSelecionado];

    return Scaffold(
      body: Column(
        children: [
          _buildSeletorMembros(),
          Expanded(
            child: _buildLinhaDoTempo(membro),
          ),
        ],
      ),
    );
  }

  Widget _buildSeletorMembros() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SegmentedButton<int>(
        segments: _membros.asMap().entries.map((entry) {
          final index = entry.key;
          final membro = entry.value;
          return ButtonSegment(
            value: index,
            label: Text(membro.nome),
            icon: Text(membro.foto, style: const TextStyle(fontSize: 20)),
          );
        }).toList(),
        selected: {_membroSelecionado},
        onSelectionChanged: (Set<int> newSelection) {
          setState(() {
            _membroSelecionado = newSelection.first;
          });
        },
      ),
    );
  }

  Widget _buildLinhaDoTempo(Membro membro) {
    // Ordena eventos por data (mais recente primeiro)
    membro.eventos.sort((a, b) => b.data.compareTo(a.data));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: membro.eventos.length,
      itemBuilder: (context, index) {
        final evento = membro.eventos[index];
        return _buildCardEvento(evento);
      },
    );
  }

  Widget _buildCardEvento(Evento evento) {
    final icon = _getIconForTipo(evento.tipo);
    final color = _getColorForTipo(evento.tipo);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 10),
                Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 5),
                Text(DateFormat('dd/MM/yyyy').format(evento.data)),
                if (evento.lembrete != null) ...[
                  const SizedBox(width: 15),
                  const Icon(Icons.notifications_active, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    'Próximo: ${DateFormat('dd/MM/yyyy').format(evento.lembrete!)}',
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
                ],
              ],
            ),
            if (evento.descricao.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(evento.descricao),
            ],
            if (evento.documentos.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Documentos:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...evento.documentos.map((doc) => ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(doc.nome),
                    subtitle: Text(doc.tipo),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _baixarDocumento(doc),
                    ),
                  )),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _editarEvento(evento),
                    child: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () => _verDetalhes(evento),
                    child: const Text('Detalhes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'Vacina':
        return Icons.medical_information;
      case 'Alergia':
        return Icons.warning;
      case 'Condição Crônica':
        return Icons.healing;
      case 'Consulta':
        return Icons.medical_services;
      default:
        return Icons.event;
    }
  }

  Color _getColorForTipo(String tipo) {
    switch (tipo) {
      case 'Vacina':
        return Colors.blue;
      case 'Alergia':
        return Colors.red;
      case 'Condição Crônica':
        return Colors.purple;
      case 'Consulta':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _baixarDocumento(Documento doc) {
    // Implementar lógica de download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Baixando ${doc.nome}')),
    );
  }

  void _editarEvento(Evento evento) {
    // Implementar edição de evento
  }

  void _verDetalhes(Evento evento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.titulo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Tipo: ${evento.tipo}'),
            Text('Data: ${DateFormat('dd/MM/yyyy').format(evento.data)}'),
            if (evento.lembrete != null)
              Text(
                  'Próximo lembrete: ${DateFormat('dd/MM/yyyy').format(evento.lembrete!)}'),
            const SizedBox(height: 15),
            const Text('Descrição:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(evento.descricao),
            if (evento.documentos.isNotEmpty) ...[
              const SizedBox(height: 15),
              const Text('Documentos:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...evento.documentos.map((doc) => ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(doc.nome),
                    subtitle: Text(doc.tipo),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _baixarDocumento(doc),
                    ),
                  )),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  void _adicionarEvento(BuildContext context) {
    // Implementar adição de novo evento
  }
}

class Membro {
  final String nome;
  final String foto;
  final List<Evento> eventos;

  Membro({
    required this.nome,
    required this.foto,
    required this.eventos,
  });
}

class Evento {
  final String tipo;
  final String titulo;
  final DateTime data;
  final String descricao;
  final DateTime? lembrete;
  final List<Documento> documentos;

  Evento({
    required this.tipo,
    required this.titulo,
    required this.data,
    required this.descricao,
    this.lembrete,
    required this.documentos,
  });
}

class Documento {
  final String nome;
  final String tipo;

  Documento({
    required this.nome,
    required this.tipo,
  });
}
