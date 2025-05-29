import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'agendamento_lembretes.dart';

class AgendamentosPage extends StatefulWidget {
  const AgendamentosPage({super.key});

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> {
  final List<Agendamento> _agendamentos = [
    Agendamento(
      tipo: 'Consulta Médica',
      titulo: 'Pediatra - Dr. Carlos',
      data: DateTime.now().add(const Duration(days: 2)),
      membros: ['João Silva'],
      local: 'Clínica Saúde Infantil',
      tipoConsulta: 'Presencial',
      lembrete: Lembrete(
        notificacao: true,
        email: true,
        assistente: true,
        antecedencia: const Duration(hours: 24),
      ),
    ),
    Agendamento(
      tipo: 'Vacinação',
      titulo: 'Gripe - Dose anual',
      data: DateTime.now().add(const Duration(days: 7)),
      membros: ['Maria Silva', 'João Silva'],
      local: 'Posto de Saúde Central',
      tipoConsulta: 'Presencial',
      lembrete: Lembrete(
        notificacao: true,
        email: false,
        assistente: true,
        antecedencia: const Duration(days: 1),
      ),
    ),
    Agendamento(
      tipo: 'Exame',
      titulo: 'Hemograma completo',
      data: DateTime.now().add(const Duration(days: 5)),
      membros: ['Maria Silva'],
      local: 'Laboratório Diagnóstico',
      tipoConsulta: 'Presencial',
      lembrete: Lembrete(
        notificacao: true,
        email: true,
        assistente: false,
        antecedencia: const Duration(hours: 12),
      ),
    ),
    Agendamento(
      tipo: 'Consulta Médica',
      titulo: 'Psicólogo - Dra. Ana',
      data: DateTime.now().add(const Duration(days: 3)),
      membros: ['Maria Silva'],
      local: 'Online - Google Meet',
      tipoConsulta: 'Virtual',
      lembrete: Lembrete(
        notificacao: true,
        email: true,
        assistente: true,
        antecedencia: const Duration(minutes: 30),
      ),
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _localController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();
  TimeOfDay _horaSelecionada = TimeOfDay.now();
  String _tipoSelecionado = 'Consulta Médica';
  String _tipoConsultaSelecionado = 'Presencial';
  final List<String> _membrosSelecionados = [];
  bool _notificacao = true;
  bool _email = false;
  bool _assistente = true;
  int _antecedenciaIndex = 1; // 24 horas por padrão

  // Em AgendamentosPage, modifique o build para:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remova o appBar daqui
      body: Column(
        children: [
          _buildFiltros(),
          Expanded(
            child: ListView.builder(
              itemCount: _agendamentos.length,
              itemBuilder: (context, index) {
                final agendamento = _agendamentos[index];
                return _buildCardAgendamento(agendamento);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _mostrarFormularioAgendamento(context),
      ),
    );
  }

  Widget _buildFiltros() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: 'Todos',
              items: ['Todos', 'Consultas', 'Vacinas', 'Exames']
                  .map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo),
                      ))
                  .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(
                labelText: 'Filtrar por',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: 'Todos',
              items: ['Todos', 'Hoje', 'Esta semana', 'Próximos 30 dias']
                  .map((periodo) => DropdownMenuItem(
                        value: periodo,
                        child: Text(periodo),
                      ))
                  .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(
                labelText: 'Período',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardAgendamento(Agendamento agendamento) {
    final isVirtual = agendamento.tipoConsulta == 'Virtual';

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _mostrarDetalhesAgendamento(agendamento),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForTipo(agendamento.tipo),
                    color: _getColorForTipo(agendamento.tipo),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    agendamento.tipo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (isVirtual)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Virtual',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                agendamento.titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('dd/MM/yyyy').format(agendamento.data),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('HH:mm').format(agendamento.data),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      agendamento.local,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 5,
                children: agendamento.membros
                    .map((membro) => Chip(
                          label: Text(membro),
                          backgroundColor: Colors.blue.shade50,
                          labelStyle: const TextStyle(fontSize: 12),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.notifications, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    'Lembrete: ${_formatLembrete(agendamento.lembrete)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'Consulta Médica':
        return Icons.medical_services;
      case 'Vacinação':
        return Icons.medical_information;
      case 'Exame':
        return Icons.assignment;
      default:
        return Icons.event;
    }
  }

  Color _getColorForTipo(String tipo) {
    switch (tipo) {
      case 'Consulta Médica':
        return Colors.green;
      case 'Vacinação':
        return Colors.orange;
      case 'Exame':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  String _formatLembrete(Lembrete lembrete) {
    final antecedencia = lembrete.antecedencia;
    String texto = '';

    if (lembrete.notificacao) texto += 'Push';
    if (lembrete.email) texto += '${texto.isNotEmpty ? ', ' : ''}Email';
    if (lembrete.assistente)
      texto += '${texto.isNotEmpty ? ', ' : ''}Assistente';

    if (antecedencia.inDays > 0) {
      texto += ' (${antecedencia.inDays} dias antes)';
    } else if (antecedencia.inHours > 0) {
      texto += ' (${antecedencia.inHours} horas antes)';
    } else {
      texto += ' (${antecedencia.inMinutes} minutos antes)';
    }

    return texto;
  }

  void _mostrarDetalhesAgendamento(Agendamento agendamento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    _getIconForTipo(agendamento.tipo),
                    color: _getColorForTipo(agendamento.tipo),
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    agendamento.tipo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                agendamento.titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoItem(Icons.calendar_today,
                  DateFormat('EEEE, dd/MM/yyyy').format(agendamento.data)),
              _buildInfoItem(Icons.access_time,
                  DateFormat('HH:mm').format(agendamento.data)),
              _buildInfoItem(Icons.location_on, agendamento.local),
              _buildInfoItem(Icons.people, agendamento.membros.join(', ')),
              const SizedBox(height: 20),
              const Text(
                'Lembretes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              if (agendamento.lembrete.notificacao)
                _buildLembreteItem(Icons.notifications, 'Notificação push'),
              if (agendamento.lembrete.email)
                _buildLembreteItem(Icons.email, 'Email'),
              if (agendamento.lembrete.assistente)
                _buildLembreteItem(Icons.assistant, 'Assistente virtual'),
              _buildLembreteItem(Icons.timer,
                  '${_formatAntecedencia(agendamento.lembrete.antecedencia)} antes'),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {},
                      child: const Text('Editar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildLembreteItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  String _formatAntecedencia(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} dias';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} horas';
    } else {
      return '${duration.inMinutes} minutos';
    }
  }

  void _mostrarFormularioAgendamento(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Novo Agendamento',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _tipoSelecionado,
                  items: ['Consulta Médica', 'Vacinação', 'Exame']
                      .map((tipo) => DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _tipoSelecionado = value!),
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Agendamento',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                    hintText: 'Ex: Pediatra - Dr. Carlos',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Por favor, insira um título' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _dataSelecionada,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() => _dataSelecionada = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Data',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(DateFormat('dd/MM/yyyy')
                              .format(_dataSelecionada)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _horaSelecionada,
                          );
                          if (time != null) {
                            setState(() => _horaSelecionada = time);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Hora',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(_horaSelecionada.format(context)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _tipoConsultaSelecionado,
                  items: ['Presencial', 'Virtual']
                      .map((tipo) => DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _tipoConsultaSelecionado = value!),
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Consulta',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _localController,
                  decoration: InputDecoration(
                    labelText: _tipoConsultaSelecionado == 'Virtual'
                        ? 'Link/Plataforma'
                        : 'Local',
                    border: const OutlineInputBorder(),
                    hintText: _tipoConsultaSelecionado == 'Virtual'
                        ? 'Ex: Google Meet, Zoom'
                        : 'Ex: Clínica Saúde, Av. Principal 123',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Por favor, insira o local' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Membros da Família',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...['Maria Silva', 'João Silva']
                    .map((membro) => CheckboxListTile(
                          title: Text(membro),
                          value: _membrosSelecionados.contains(membro),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _membrosSelecionados.add(membro);
                              } else {
                                _membrosSelecionados.remove(membro);
                              }
                            });
                          },
                        )),
                const SizedBox(height: 16),
                const Text(
                  'Lembretes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                CheckboxListTile(
                  title: const Text('Notificação Push'),
                  value: _notificacao,
                  onChanged: (value) =>
                      setState(() => _notificacao = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Email'),
                  value: _email,
                  onChanged: (value) => setState(() => _email = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Assistente Virtual'),
                  value: _assistente,
                  onChanged: (value) =>
                      setState(() => _assistente = value ?? false),
                ),
                const SizedBox(height: 10),
                const Text('Antecedência do lembrete'),
                Slider(
                  value: _antecedenciaIndex.toDouble(),
                  min: 0,
                  max: 4,
                  divisions: 4,
                  label: _getAntecedenciaLabel(_antecedenciaIndex),
                  onChanged: (value) =>
                      setState(() => _antecedenciaIndex = value.toInt()),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: _salvarAgendamento,
                        child: const Text('Salvar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getAntecedenciaLabel(int index) {
    switch (index) {
      case 0:
        return '30 minutos antes';
      case 1:
        return '1 hora antes';
      case 2:
        return '24 horas antes';
      case 3:
        return '2 dias antes';
      case 4:
        return '1 semana antes';
      default:
        return '';
    }
  }

  Duration _getAntecedenciaDuration(int index) {
    switch (index) {
      case 0:
        return const Duration(minutes: 30);
      case 1:
        return const Duration(hours: 1);
      case 2:
        return const Duration(hours: 24);
      case 3:
        return const Duration(days: 2);
      case 4:
        return const Duration(days: 7);
      default:
        return const Duration(hours: 24);
    }
  }

  void _salvarAgendamento() {
    if (_formKey.currentState!.validate() && _membrosSelecionados.isNotEmpty) {
      final novaData = DateTime(
        _dataSelecionada.year,
        _dataSelecionada.month,
        _dataSelecionada.day,
        _horaSelecionada.hour,
        _horaSelecionada.minute,
      );

      final novoAgendamento = Agendamento(
        tipo: _tipoSelecionado,
        titulo: _tituloController.text,
        data: novaData,
        membros: List.from(_membrosSelecionados),
        local: _localController.text,
        tipoConsulta: _tipoConsultaSelecionado,
        lembrete: Lembrete(
          notificacao: _notificacao,
          email: _email,
          assistente: _assistente,
          antecedencia: _getAntecedenciaDuration(_antecedenciaIndex),
        ),
      );

      setState(() {
        _agendamentos.add(novoAgendamento);
        _tituloController.clear();
        _localController.clear();
        _membrosSelecionados.clear();
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento salvo com sucesso!')),
      );
    } else if (_membrosSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selecione pelo menos um membro da família')),
      );
    }
  }

  void _mostrarBusca() {
    showSearch(
      context: context,
      delegate: _AgendamentoSearchDelegate(_agendamentos),
    );
  }
}

class _AgendamentoSearchDelegate extends SearchDelegate {
  final List<Agendamento> agendamentos;

  _AgendamentoSearchDelegate(this.agendamentos);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = agendamentos.where((a) =>
        a.titulo.toLowerCase().contains(query.toLowerCase()) ||
        a.tipo.toLowerCase().contains(query.toLowerCase()) ||
        a.local.toLowerCase().contains(query.toLowerCase()) ||
        a.membros.any((m) => m.toLowerCase().contains(query.toLowerCase())));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final agendamento = results.elementAt(index);
        return ListTile(
          title: Text(agendamento.titulo),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(agendamento.data)),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: Text(agendamento.titulo)),
                  body: Center(
                    child: Text('Detalhes de ${agendamento.titulo}'),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? agendamentos.take(5).toList()
        : agendamentos.where((a) =>
            a.titulo.toLowerCase().contains(query.toLowerCase()) ||
            a.tipo.toLowerCase().contains(query.toLowerCase()) ||
            a.local.toLowerCase().contains(query.toLowerCase()) ||
            a.membros
                .any((m) => m.toLowerCase().contains(query.toLowerCase())));

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final agendamento = suggestions.elementAt(index);
        return ListTile(
          leading: Icon(_getIconForTipo(agendamento.tipo)),
          title: Text(agendamento.titulo),
          subtitle: Text(
              '${agendamento.tipo} - ${DateFormat('dd/MM/yyyy').format(agendamento.data)}'),
          onTap: () {
            query = agendamento.titulo;
            showResults(context);
          },
        );
      },
    );
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'Consulta Médica':
        return Icons.medical_services;
      case 'Vacinação':
        return Icons.medical_information;
      case 'Exame':
        return Icons.assignment;
      default:
        return Icons.event;
    }
  }
}

class Agendamento {
  final String tipo;
  final String titulo;
  final DateTime data;
  final List<String> membros;
  final String local;
  final String tipoConsulta;
  final Lembrete lembrete;

  Agendamento({
    required this.tipo,
    required this.titulo,
    required this.data,
    required this.membros,
    required this.local,
    required this.tipoConsulta,
    required this.lembrete,
  });
}

class Lembrete {
  final bool notificacao;
  final bool email;
  final bool assistente;
  final Duration antecedencia;

  Lembrete({
    required this.notificacao,
    required this.email,
    required this.assistente,
    required this.antecedencia,
  });
}
