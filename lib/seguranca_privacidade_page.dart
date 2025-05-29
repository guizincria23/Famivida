import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SegurancaPrivacidadePage extends StatefulWidget {
  const SegurancaPrivacidadePage({super.key});

  @override
  State<SegurancaPrivacidadePage> createState() =>
      _SegurancaPrivacidadePageState();
}

class _SegurancaPrivacidadePageState extends State<SegurancaPrivacidadePage> {
  final List<Membro> _membros = [
    Membro(
      nome: 'Maria Silva',
      foto: '👩',
      nivelPrivacidade: NivelPrivacidade.compartilhado,
      permissoes: [
        Permissao(
            usuario: 'Carlos Silva',
            tipo: 'Responsável',
            leitura: true,
            edicao: true),
        Permissao(
            usuario: 'Dra. Ana', tipo: 'Médico', leitura: true, edicao: false),
      ],
      acessos: [
        Acesso(
            usuario: 'Carlos Silva',
            data: DateTime.now().subtract(const Duration(hours: 2))),
        Acesso(
            usuario: 'Dra. Ana',
            data: DateTime.now().subtract(const Duration(days: 1))),
      ],
    ),
    Membro(
      nome: 'João Silva',
      foto: '👦',
      nivelPrivacidade: NivelPrivacidade.medicos,
      permissoes: [
        Permissao(
            usuario: 'Maria Silva',
            tipo: 'Responsável',
            leitura: true,
            edicao: true),
        Permissao(
            usuario: 'Dr. Carlos',
            tipo: 'Médico',
            leitura: true,
            edicao: false),
      ],
      acessos: [
        Acesso(
            usuario: 'Maria Silva',
            data: DateTime.now().subtract(const Duration(days: 1))),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._membros.map((membro) => _buildCardMembro(membro)).toList(),
            const SizedBox(height: 30),
            const Text(
              'Histórico de Acessos Recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildListaAcessos(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMembro(Membro membro) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(membro.foto, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(
                  membro.nome,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Nível de Privacidade:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<NivelPrivacidade>(
              value: membro.nivelPrivacidade,
              items: NivelPrivacidade.values.map((nivel) {
                return DropdownMenuItem<NivelPrivacidade>(
                  value: nivel,
                  child: Text(_getLabelNivelPrivacidade(nivel)),
                );
              }).toList(),
              onChanged: (NivelPrivacidade? novoNivel) {
                if (novoNivel != null) {
                  setState(() {
                    membro.nivelPrivacidade = novoNivel;
                  });
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Permissões:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...membro.permissoes.map((permissao) => SwitchListTile(
                  title: Text('${permissao.usuario} (${permissao.tipo})'),
                  subtitle: Text(
                      'Leitura: ${permissao.leitura ? 'Sim' : 'Não'} • Edição: ${permissao.edicao ? 'Sim' : 'Não'}'),
                  secondary: Icon(
                    permissao.tipo == 'Médico'
                        ? Icons.medical_services
                        : Icons.person,
                    color: Colors.blueGrey,
                  ),
                  value: permissao.leitura,
                  onChanged: permissao.tipo == 'Médico'
                      ? null // Médicos só podem ter permissão de leitura
                      : (value) {
                          setState(() {
                            permissao.leitura = value;
                            if (!value) permissao.edicao = false;
                          });
                        },
                )),
            ...membro.permissoes
                .where((p) => p.leitura)
                .map((permissao) => Padding(
                      padding: const EdgeInsets.only(left: 72, right: 16),
                      child: SwitchListTile(
                        title: const Text('Permitir edição'),
                        subtitle: Text('Para ${permissao.usuario}'),
                        value: permissao.edicao,
                        onChanged: permissao.tipo == 'Médico'
                            ? null // Médicos não podem ter permissão de edição
                            : (value) {
                                setState(() {
                                  permissao.edicao = value;
                                });
                              },
                      ),
                    )),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Adicionar Permissão'),
                onPressed: () => _adicionarPermissao(membro),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaAcessos() {
    final todosAcessos = _membros.expand((m) => m.acessos).toList();
    todosAcessos.sort((a, b) => b.data.compareTo(a.data));

    return Card(
      child: Column(
        children: [
          ...todosAcessos.take(5).map((acesso) => ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(acesso.usuario),
                subtitle:
                    Text(DateFormat('dd/MM/yyyy HH:mm').format(acesso.data)),
                trailing: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () => _mostrarDetalhesAcesso(acesso),
                ),
              )),
          if (todosAcessos.length > 5)
            TextButton(
              child: const Text('Ver histórico completo'),
              onPressed: () => _verHistoricoCompleto(),
            ),
        ],
      ),
    );
  }

  String _getLabelNivelPrivacidade(NivelPrivacidade nivel) {
    switch (nivel) {
      case NivelPrivacidade.privado:
        return 'Totalmente privado';
      case NivelPrivacidade.compartilhado:
        return 'Compartilhado com responsáveis';
      case NivelPrivacidade.medicos:
        return 'Visível apenas para médicos';
    }
  }

  void _adicionarPermissao(Membro membro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Permissão'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nome do usuário'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              items: ['Responsável', 'Médico'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Tipo de acesso'),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Permissão adicionada com sucesso')),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhesAcesso(Acesso acesso) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalhes do Acesso',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text('Usuário: ${acesso.usuario}'),
            Text('Data: ${DateFormat('dd/MM/yyyy HH:mm').format(acesso.data)}'),
            const SizedBox(height: 15),
            const Text('Ações realizadas:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('• Visualização de dados médicos'),
            const Text('• Download de receita médica'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
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

  void _verHistoricoCompleto() {
    // Implementar navegação para histórico completo
  }
}

class Membro {
  String nome;
  String foto;
  NivelPrivacidade nivelPrivacidade;
  List<Permissao> permissoes;
  List<Acesso> acessos;

  Membro({
    required this.nome,
    required this.foto,
    required this.nivelPrivacidade,
    required this.permissoes,
    required this.acessos,
  });
}

enum NivelPrivacidade {
  privado,
  compartilhado,
  medicos,
}

class Permissao {
  String usuario;
  String tipo;
  bool leitura;
  bool edicao;

  Permissao({
    required this.usuario,
    required this.tipo,
    required this.leitura,
    required this.edicao,
  });
}

class Acesso {
  String usuario;
  DateTime data;

  Acesso({
    required this.usuario,
    required this.data,
  });
}
