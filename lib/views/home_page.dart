import 'package:chatbot/models/chat_message.dart';
import 'package:chatbot/widgets/chat_message_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt').format(now);
    return Scaffold(
      appBar: new AppBar(
        title: Text('Vitas - Chat'),
        centerTitle: true,
        backgroundColor: Color(0xffee2020),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.grey[400],
                width: 3.0,
              ),
            ), //
            child: Text(
              formattedDate,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20.0,
                backgroundColor: Colors.grey[400],
              ),
            ),
          ),
          _buildList(),
          Divider(height: 1.0),
          _buildUserInput(),
        ],
      ),
    );
  }

  // Cria a lista de mensagens (de baixo para cima)
  Widget _buildList() {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) =>
            ChatMessageListItem(chatMessage: _messageList[index]),
        itemCount: _messageList.length,
      ),
    );
  }

  // Envia uma mensagem com o padrão a direita
  void _sendMessage({String text}) {
    _controllerText.clear();
    _addMessage(text: text, type: ChatMessageType.sent);
  }

  // Adiciona uma mensagem na lista de mensagens
  void _addMessage({String name, String text, ChatMessageType type}) {
    var message = ChatMessage(text: text, /*name: name,*/ type: type);
    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);
    }
  }

  Future _dialogFlowRequest({String query}) async {
    // Adiciona uma mensagem temporária na lista
    _addMessage(
      text: 'Escrevendo...',
      type: ChatMessageType.received,
    );
    // Faz a autenticação com o serviço, envia a mensagem e recebe uma resposta da Intent
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/vitas-kcpvnu-6a7310583ffe.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: "pt-BR");
    AIResponse response = await dialogflow.detectIntent(query);

    // remove a mensagem temporária
    setState(() {
      _messageList.removeAt(0);
    });

    // adiciona a mensagem com a resposta do DialogFlow
    _addMessage(
        text: response.queryResult.fulfillmentText,
        type: ChatMessageType.received);
  }

  // Campo para escrever a mensagem
  Widget _buildTextField() {
    return new Flexible(
      child: Container(
        margin: new EdgeInsets.only(left: 8.0),
        height: 75,
        child: Center(
          child: new TextField(
            controller: _controllerText,
            decoration: new InputDecoration(
              border: OutlineInputBorder(
                gapPadding: 4,
                borderRadius: const BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              hintText: "Diga 'Olá Vitas'",
            ),
          ),
        ),
      ),
    );
  }

  // Botão para enviar a mensagem
  Widget _buildSendButton() {
    return new Container(
      margin: new EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey[300],
          width: 3.0,
        ),
      ),
      child: new IconButton(
        icon: new Icon(
          Icons.send,
          color: Color(0xffee2020),
        ),
        iconSize: 30.0,
        onPressed: () {
          if (_controllerText.text.isNotEmpty) {
            _sendMessage(text: _controllerText.text);
          }
        },
      ),
    );
  }

  // Monta uma linha com o campo de text e o botão de enviao
  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          _buildTextField(),
          _buildSendButton(),
        ],
      ),
    );
  }
}
