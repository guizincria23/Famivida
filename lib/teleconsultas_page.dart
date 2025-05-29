import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeleconsultasPage extends StatefulWidget {
  const TeleconsultasPage({super.key});

  @override
  State<TeleconsultasPage> createState() => _TeleconsultasPageState();
}

class _TeleconsultasPageState extends State<TeleconsultasPage> {
  final List<Consulta> _consultas = [
    Consulta(
      titulo: 'Pediatra - Dra. Ana',
      data: DateTime.now().add(const Duration(days: 1, hours: 2)),
      participantes: ['Maria Silva', 'João Silva', 'Dra. Ana'],
      plataforma: 'Google Meet',
      link: 'https://meet.google.com/abc-xyz-123',
      documentos: [
        Documento(nome: 'Exame de sangue', tipo: 'PDF', tamanho: '2.4 MB'),
        Documento(nome: 'Raio-X', tipo: 'JPG', tamanho: '1.8 MB'),
      ],
      anotacoes: [
        Anotacao(
          autor: 'Dra. Ana',
          texto: 'Receitar vitamina D',
          data: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
    Consulta(
      titulo: 'Cardiologista - Dr. Carlos',
      data: DateTime.now().add(const Duration(days: 3)),
      participantes: ['Maria Silva', 'Dr. Carlos'],
      plataforma: 'Zoom',
      link: 'https://zoom.us/j/123456789',
      documentos: [
        Documento(nome: 'Eletrocardiograma', tipo: 'PDF', tamanho: '3.1 MB'),
      ],
      anotacoes: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _consultas.length,
        itemBuilder: (context, index) {
          final consulta = _consultas[index];
          return _buildCardConsulta(consulta);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.video_call),
        onPressed: () => _iniciarNovaConsulta(context),
      ),
    );
  }

  Widget _buildCardConsulta(Consulta consulta) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: Colors.green),
                const SizedBox(width: 10),
                Text(
                  consulta.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 5),
                Text(DateFormat('dd/MM/yyyy - HH:mm').format(consulta.data)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.video_call, size: 16),
                const SizedBox(width: 5),
                Text(consulta.plataforma),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Participantes:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 5,
              children: consulta.participantes
                  .map((p) => Chip(
                      label: Text(p), backgroundColor: Colors.green.shade50))
                  .toList(),
            ),
            if (consulta.documentos.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Documentos:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...consulta.documentos.map((doc) => ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(doc.nome),
                    subtitle: Text('${doc.tipo} • ${doc.tamanho}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _baixarDocumento(doc),
                    ),
                  )),
            ],
            if (consulta.anotacoes.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Anotações:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...consulta.anotacoes.map((anot) => ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(anot.autor),
                    subtitle: Text(anot.texto),
                    trailing: Text(DateFormat('HH:mm').format(anot.data)),
                  )),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.assistant),
                    label: const Text('Assistente Virtual'),
                    onPressed: () => _acessarAssistenteVirtual(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.video_call),
                    label: const Text('Entrar'),
                    onPressed: () => _entrarConsulta(consulta),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _entrarConsulta(Consulta consulta) {
    // Implementar lógica para entrar na consulta
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Iniciar Consulta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Você será redirecionado para:'),
            Text(consulta.plataforma,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Link:'),
            SelectableText(consulta.link,
                style: const TextStyle(color: Colors.blue)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Aqui você implementaria a integração com a plataforma de vídeo
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Conectando à consulta com ${consulta.titulo}')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _baixarDocumento(Documento doc) {
    // Implementar lógica de download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Baixando ${doc.nome}')),
    );
  }

  void _acessarAssistenteVirtual() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Assistente Virtual',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Consultar calendário de saúde'),
              onTap: () {
                Navigator.pop(context);
                _mostrarCalendarioSaude();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Configurar lembretes'),
              onTap: () {
                Navigator.pop(context);
                _configurarLembretes();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ajuda com a teleconsulta'),
              onTap: () {
                Navigator.pop(context);
                _mostrarAjudaConsulta();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarCalendarioSaude() {
    // Implementar integração com calendário
  }

  void _configurarLembretes() {
    // Implementar integração com assistentes virtuais
  }

  void _mostrarAjudaConsulta() {
    // Implementar ajuda
  }

  void _iniciarNovaConsulta(BuildContext context) {
    // Implementar criação de nova consulta
  }

  void _mostrarFormularioConsulta(BuildContext context) {
    // Implementar formulário de agendamento
  }
}

class Consulta {
  final String titulo;
  final DateTime data;
  final List<String> participantes;
  final String plataforma;
  final String link;
  final List<Documento> documentos;
  final List<Anotacao> anotacoes;

  Consulta({
    required this.titulo,
    required this.data,
    required this.participantes,
    required this.plataforma,
    required this.link,
    required this.documentos,
    required this.anotacoes,
  });
}

class Documento {
  final String nome;
  final String tipo;
  final String tamanho;

  Documento({
    required this.nome,
    required this.tipo,
    required this.tamanho,
  });
}

class Anotacao {
  final String autor;
  final String texto;
  final DateTime data;

  Anotacao({
    required this.autor,
    required this.texto,
    required this.data,
  });
}
