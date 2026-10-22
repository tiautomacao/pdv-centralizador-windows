-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 10/10/2025 às 18:52
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `walinux`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `checklist_fiscal`
--

CREATE TABLE `checklist_fiscal` (
  `_id` int(11) NOT NULL,
  `check_loja_nome` int(11) DEFAULT NULL,
  `check_razao_social` int(11) DEFAULT NULL,
  `check_CNPJ` int(11) DEFAULT NULL,
  `check_IE` int(11) DEFAULT NULL,
  `check_IM` int(11) DEFAULT NULL,
  `check_endereco` int(11) DEFAULT NULL,
  `check_municipio_UF` int(11) DEFAULT NULL,
  `check_telefone` int(11) DEFAULT NULL,
  `check_email` int(11) DEFAULT NULL,
  `check_ID_empresa` int(11) DEFAULT NULL,
  `check_ID_loja` int(11) DEFAULT NULL,
  `check_nfce_csc` int(11) DEFAULT NULL,
  `check_nfce_crt` int(11) DEFAULT NULL,
  `check_nfce_imp_daruma` int(11) DEFAULT NULL,
  `check_nfce_certificado_A1` int(11) DEFAULT NULL,
  `check_nfce_chave_migrate` int(11) DEFAULT NULL,
  `check_nfce_ncm_produtos` int(11) DEFAULT NULL,
  `check_sat_cadastro_SEFAZ` int(11) DEFAULT NULL,
  `check_sat_ativacao` int(11) DEFAULT NULL,
  `check_sat_vincular_signAC` int(11) DEFAULT NULL,
  `check_sat_senha_seguranca` int(11) DEFAULT NULL,
  `check_sat_chave_AC` int(11) DEFAULT NULL,
  `check_nfse_chave_migrate` int(11) DEFAULT NULL,
  `check_nfse_aliquota_issqn` int(11) DEFAULT NULL,
  `check_nfse_certificado_A1` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente`
--

CREATE TABLE `cliente` (
  `_id` int(11) NOT NULL,
  `cli_nome` varchar(100) DEFAULT NULL,
  `cli_endereco` varchar(100) DEFAULT NULL,
  `cli_fone1` varchar(22) DEFAULT NULL,
  `cli_fone2` varchar(22) DEFAULT NULL,
  `cli_email` varchar(100) DEFAULT NULL,
  `cli_obs` varchar(300) DEFAULT NULL,
  `cli_alerta` varchar(40) DEFAULT NULL,
  `cli_ativo` int(11) DEFAULT NULL,
  `cli_endereco_nro` varchar(10) DEFAULT '',
  `cli_end_bairro` varchar(100) DEFAULT NULL,
  `cli_end_compl` varchar(200) DEFAULT NULL,
  `cli_end_cidade` varchar(100) DEFAULT NULL,
  `cli_end_uf` varchar(50) DEFAULT NULL,
  `cli_cod_municipio` varchar(10) DEFAULT '',
  `cli_cnpj_cpf` varchar(25) DEFAULT '',
  `cli_ie` varchar(20) DEFAULT '',
  `cli_im` varchar(20) DEFAULT '',
  `cli_end_cep` varchar(10) DEFAULT '',
  `cli_codigo_parceiro` int(11) DEFAULT NULL,
  `cli_sinc_serv` int(11) DEFAULT 0,
  `cli_sinc_cloud` int(11) DEFAULT 0,
  `cli_cod_externo` int(11) DEFAULT 0,
  `cli_dt_alt` datetime DEFAULT NULL,
  `cli_taxa_id` int(11) DEFAULT 0,
  `cli_uuid` text NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Despejando dados para a tabela `cliente`
--

INSERT INTO `cliente` (`_id`, `cli_nome`, `cli_endereco`, `cli_fone1`, `cli_fone2`, `cli_email`, `cli_obs`, `cli_alerta`, `cli_ativo`, `cli_endereco_nro`, `cli_end_bairro`, `cli_end_compl`, `cli_end_cidade`, `cli_end_uf`, `cli_cod_municipio`, `cli_cnpj_cpf`, `cli_ie`, `cli_im`, `cli_end_cep`, `cli_codigo_parceiro`, `cli_sinc_serv`, `cli_sinc_cloud`, `cli_cod_externo`, `cli_dt_alt`, `cli_taxa_id`, `cli_uuid`) VALUES
(1, 'CLIENTE DEMONSTRACAO', 'Rua NONONO', '12-34567-8901', NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, '', '', '', '', '', NULL, 0, 0, 0, NULL, 0, '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `conferencia`
--

CREATE TABLE `conferencia` (
  `_id` int(11) NOT NULL,
  `conf_dtmovto` datetime DEFAULT NULL,
  `conf_usua_id` int(11) DEFAULT NULL,
  `conf_form_pag_id` int(11) DEFAULT NULL,
  `conf_vl_inf` decimal(10,2) DEFAULT NULL,
  `conf_vl_sis` decimal(10,2) DEFAULT NULL,
  `conf_dt_encerra` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `configuracao`
--

CREATE TABLE `configuracao` (
  `_id` int(11) NOT NULL,
  `cfg_empresa_nome` varchar(40) DEFAULT NULL,
  `cfg_empresa_id` int(11) DEFAULT NULL,
  `cfg_loja_nome` varchar(40) DEFAULT NULL,
  `cfg_loja_id` int(11) DEFAULT NULL,
  `cfg_terminal_nome` varchar(40) DEFAULT NULL,
  `cfg_terminal_id` int(11) DEFAULT NULL,
  `cfg_terminal_mac` varchar(50) DEFAULT NULL,
  `cfg_senha_ws` varchar(20) DEFAULT NULL,
  `cfg_cabecalho` varchar(40) DEFAULT NULL,
  `cfg_rodape` varchar(40) DEFAULT NULL,
  `cfg_desc_max_item` decimal(10,2) DEFAULT NULL,
  `cfg_desc_max_conta` decimal(10,2) DEFAULT NULL,
  `cfg_imp_relatorio` int(11) DEFAULT NULL,
  `cfg_imp_caixa` int(11) DEFAULT NULL,
  `cfg_termo_adesao` int(11) DEFAULT NULL,
  `cfg_inst_inicial` int(11) DEFAULT NULL,
  `cfg_identifica_venda` int(11) DEFAULT NULL,
  `cfg_retaguarda` int(11) DEFAULT NULL,
  `cfg_identifica_obrig` int(11) DEFAULT NULL,
  `cfg_imp_conferencia` int(11) DEFAULT NULL,
  `cfg_eh_servidor` int(11) DEFAULT NULL,
  `cfg_ip_servidor` varchar(15) DEFAULT NULL,
  `cfg_porta_servidor` varchar(9) DEFAULT NULL,
  `cfg_taxa` decimal(10,2) DEFAULT NULL,
  `cfg_digito_balanca` int(11) DEFAULT NULL,
  `cfg_nfce` int(11) DEFAULT NULL,
  `cfg_serie_nfce` varchar(10) DEFAULT NULL,
  `cfg_tipo_ambiente` varchar(15) DEFAULT NULL,
  `cfg_chave_nfce` varchar(60) DEFAULT NULL,
  `cfg_chave_nfse` varchar(60) DEFAULT NULL,
  `cfg_cod_municipio` varchar(10) DEFAULT NULL,
  `cfg_cod_uf` varchar(10) DEFAULT NULL,
  `cfg_cod_crt` varchar(10) DEFAULT NULL,
  `cfg_razao_social` varchar(60) DEFAULT NULL,
  `cfg_nome_fantasia` varchar(60) DEFAULT NULL,
  `cfg_cnpj` varchar(20) DEFAULT NULL,
  `cfg_ie` varchar(15) DEFAULT NULL,
  `cfg_im` varchar(15) DEFAULT NULL,
  `cfg_end_logradouro` varchar(50) DEFAULT NULL,
  `cfg_end_numero` varchar(15) DEFAULT NULL,
  `cfg_end_bairro` varchar(35) DEFAULT NULL,
  `cfg_end_cidade` varchar(50) DEFAULT NULL,
  `cfg_end_uf` char(2) DEFAULT NULL,
  `cfg_end_cep` varchar(10) DEFAULT NULL,
  `cfg_token_id_nfce` varchar(10) DEFAULT NULL,
  `cfg_token_nfce` varchar(80) DEFAULT NULL,
  `cfg_balanca_marca` varchar(25) DEFAULT NULL,
  `cfg_balanca_pareamento` varchar(25) DEFAULT NULL,
  `cfg_tef_house` varchar(25) DEFAULT NULL,
  `cfg_dtacesso` datetime DEFAULT NULL,
  `cfg_eh_rede_card` int(11) DEFAULT NULL,
  `cfg_modulo_food` int(11) DEFAULT NULL,
  `cfg_modulo_food_tag` varchar(15) DEFAULT NULL,
  `cfg_sat` int(11) DEFAULT NULL,
  `cfg_marca_sat` varchar(40) DEFAULT NULL,
  `cfg_codigo_ativacao_sat` varchar(40) DEFAULT NULL,
  `cfg_numero_caixa_sat` varchar(3) DEFAULT NULL,
  `cfg_signac_sat` varchar(355) DEFAULT NULL,
  `cfg_email` varchar(100) DEFAULT NULL,
  `cfg_telefone` varchar(40) DEFAULT NULL,
  `cfg_chave_ibpt` varchar(555) DEFAULT NULL,
  `cfg_nfse` int(11) DEFAULT NULL,
  `cfg_serie_nfse` varchar(10) DEFAULT NULL,
  `cfg_nfce_nu_inicial` int(11) DEFAULT NULL,
  `cfg_nfse_nu_inicial` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `control_version`
--

CREATE TABLE `control_version` (
  `cvers_terminal_mac` varchar(20) NOT NULL COMMENT 'Terminal MAC Tag',
  `cvers_terminal_name` text NOT NULL COMMENT 'Terminal Name',
  `cvers_version` text NOT NULL COMMENT 'App Version',
  `cvers_terminal_brand` text NOT NULL DEFAULT '',
  `cvers_terminal_model` text NOT NULL DEFAULT '',
  `cvers_terminal_dt_update` text NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Despejando dados para a tabela `control_version`
--

INSERT INTO `control_version` (`cvers_terminal_mac`, `cvers_terminal_name`, `cvers_version`, `cvers_terminal_brand`, `cvers_terminal_model`, `cvers_terminal_dt_update`) VALUES
('07B5469A0A35', '07B5469A0A35', '25.09.01.750', 'Xiaomi', '24030PN60G', '2025/10/10 11:31:21'),
('0D82C8312D4F', 'SUNMI', '24.09.01.470', 'SUNMI', 'D2mini', '2024/12/12 17:26:58'),
('0E6EFA3715E5', 'AILTONCELL', '24.08.01.650', 'samsung', 'SM-G781B', '2024/09/24 17:42:53'),
('436102FE9C22', 'AILTONPC', '25.05.01.250', 'Windows', 'Subsystem for Android(TM)', '2025/08/19 16:28:27'),
('5773E95398A1', 'EMULADORYAGO', '25.07.01.350', 'google', 'Pixel 5', '2025/08/20 12:05:37'),
('89EB49499FC9', 'POSSTONE', '24.07.01.100', 'SUNMI', 'P2-B', '2024/09/23 14:48:14'),
('8D3823877D34', 'CELLPLANTAO', '24.07.01.100', 'Redmi', '220333QL', '2024/09/13 16:13:33');

-- --------------------------------------------------------

--
-- Estrutura para tabela `formapagto`
--

CREATE TABLE `formapagto` (
  `_id` int(11) NOT NULL,
  `form_pag_descricao` varchar(20) DEFAULT NULL,
  `form_pag_tipo` int(11) DEFAULT NULL,
  `form_pag_ativo` int(11) DEFAULT NULL,
  `form_pag_tef_ativo` int(11) DEFAULT NULL,
  `form_pag_tef_parcelas` int(11) DEFAULT NULL,
  `form_pag_tef_provedor` varchar(20) DEFAULT NULL,
  `form_pag_tef_financ` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `grupoproduto`
--

CREATE TABLE `grupoproduto` (
  `_id` int(11) NOT NULL,
  `grup_nome` varchar(25) DEFAULT NULL,
  `grup_ativo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `impressora`
--

CREATE TABLE `impressora` (
  `_id` int(11) NOT NULL,
  `imp_nome` varchar(30) DEFAULT NULL,
  `imp_ip` varchar(16) DEFAULT NULL,
  `imp_port` varchar(16) DEFAULT NULL,
  `imp_cortar` int(11) DEFAULT NULL,
  `imp_gaveta` int(11) DEFAULT NULL,
  `imp_tamanho_fonte` int(11) DEFAULT NULL,
  `imp_modelo` varchar(40) DEFAULT NULL,
  `imp_cabecalho` varchar(40) DEFAULT NULL,
  `imp_ativo` int(11) DEFAULT NULL,
  `imp_vale` int(11) DEFAULT NULL,
  `imp_marca` varchar(20) DEFAULT NULL,
  `imp_interface` int(11) DEFAULT NULL,
  `imp_margem_superior` int(11) DEFAULT NULL,
  `imp_margem_inferior` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `modificador`
--

CREATE TABLE `modificador` (
  `_id` int(11) NOT NULL DEFAULT 0,
  `mod_prod_id` int(11) DEFAULT NULL,
  `mod_descricao` text DEFAULT NULL,
  `mod_classificacao` text DEFAULT NULL,
  `mod_preco` decimal(10,3) DEFAULT 0.000,
  `mod_qtd_min` int(11) DEFAULT 0,
  `mod_qtd_max` int(11) DEFAULT 0,
  `mod_baixa_estoque` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `movimento`
--

CREATE TABLE `movimento` (
  `_id` int(11) NOT NULL,
  `mov_dtmovto` datetime DEFAULT NULL,
  `mov_dtencerra` datetime DEFAULT NULL,
  `mov_usua_id_encerra` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `perfil`
--

CREATE TABLE `perfil` (
  `_id` int(11) NOT NULL,
  `perf_nome` varchar(20) DEFAULT NULL,
  `perf_cadastro` int(11) DEFAULT NULL,
  `perf_config` int(11) DEFAULT NULL,
  `perf_vendas` int(11) DEFAULT NULL,
  `perf_consulta` int(11) DEFAULT NULL,
  `perf_suprir` int(11) DEFAULT NULL,
  `perf_sangria` int(11) DEFAULT NULL,
  `perf_encerra` int(11) DEFAULT NULL,
  `perf_relatorio` int(11) DEFAULT NULL,
  `perf_sair` int(11) DEFAULT NULL,
  `perf_pre_venda` int(11) DEFAULT NULL,
  `perf_recebe_conta` int(11) DEFAULT NULL,
  `perf_desc_item` int(11) DEFAULT NULL,
  `perf_desc_conta` int(11) DEFAULT NULL,
  `perf_ult_vendas` int(11) DEFAULT NULL,
  `perf_estorno` int(11) DEFAULT NULL,
  `perf_pendura` int(11) DEFAULT NULL,
  `perf_identifica_atendente` int(11) DEFAULT NULL,
  `perf_altera_acrescimo` int(11) DEFAULT NULL,
  `perf_reabre_conta` int(11) DEFAULT NULL,
  `perf_transfere_produtos` int(11) DEFAULT NULL,
  `perf_preferencia_balcao` int(11) DEFAULT NULL,
  `perf_loga_cada_venda` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `_id` int(11) NOT NULL,
  `prod_codigo` varchar(20) DEFAULT NULL,
  `prod_desc_cupom` varchar(20) DEFAULT NULL,
  `prod_desc_detal` varchar(150) DEFAULT NULL,
  `prod_grup_id` int(11) DEFAULT NULL,
  `prod_un` varchar(2) DEFAULT NULL,
  `prod_preco` decimal(10,2) DEFAULT NULL,
  `prod_foto_path` varchar(100) DEFAULT NULL,
  `prod_impr_id` int(11) DEFAULT NULL,
  `prod_impr_id2` int(11) DEFAULT NULL,
  `prod_tipo` int(11) DEFAULT NULL,
  `prod_local_estoque` varchar(50) DEFAULT NULL,
  `prod_ativo` int(11) DEFAULT NULL,
  `prod_balanca` int(11) DEFAULT NULL,
  `prod_desconto` int(11) DEFAULT NULL,
  `prod_fracionado` int(11) DEFAULT NULL,
  `prod_dt_alt` datetime DEFAULT NULL,
  `prod_requer_qtde` int(11) DEFAULT NULL,
  `prod_requer_modif` int(11) DEFAULT NULL,
  `prod_venda_rapida` int(11) DEFAULT NULL,
  `prod_taxa` int(11) DEFAULT NULL,
  `prod_aliquota` varchar(20) DEFAULT NULL,
  `prod_ncm` varchar(20) DEFAULT NULL,
  `prod_origem` int(11) DEFAULT NULL,
  `prod_cfop` varchar(6) DEFAULT NULL,
  `prod_csosn` varchar(3) DEFAULT NULL,
  `prod_cst` varchar(2) DEFAULT NULL,
  `prod_pis` decimal(10,2) DEFAULT NULL,
  `prod_cofins` decimal(10,2) DEFAULT NULL,
  `prod_codigo_servico` int(11) DEFAULT NULL,
  `prod_ncm_fnacional` decimal(10,2) DEFAULT NULL,
  `prod_ncm_fimportado` decimal(10,2) DEFAULT NULL,
  `prod_ncm_estadual` decimal(10,2) DEFAULT NULL,
  `prod_cod_externo` int(11) DEFAULT NULL,
  `prod_baixa_estoque` int(11) DEFAULT NULL,
  `prod_acrescimo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto_integracao`
--

CREATE TABLE `produto_integracao` (
  `prodi_prod_cod_externo` int(11) NOT NULL,
  `prodi_prod_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `reference_order_log`
--

CREATE TABLE `reference_order_log` (
  `reford_number` varchar(36) NOT NULL COMMENT 'Reference of order',
  `reford_status` varchar(10) DEFAULT NULL COMMENT 'dispatched integrated concluded cancelled',
  `reford_partner` varchar(30) DEFAULT NULL COMMENT 'Ifood Dlv Legal JotaJa  AnotaAi',
  `reford_guid` varchar(44) DEFAULT NULL COMMENT 'Guid when available',
  `reford_date` datetime DEFAULT NULL,
  `reford_sync` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `sangria`
--

CREATE TABLE `sangria` (
  `_id` int(11) NOT NULL,
  `sangr_descricao` varchar(50) DEFAULT NULL,
  `sangr_dtmovto` datetime DEFAULT NULL,
  `sangr_dtabre` datetime DEFAULT NULL,
  `sangr_usua_id` int(11) DEFAULT NULL,
  `sangr_valor` decimal(10,2) DEFAULT NULL,
  `sangr_usua_cancelou` int(11) DEFAULT NULL,
  `sangr_dtcancela` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `suprimento`
--

CREATE TABLE `suprimento` (
  `_id` int(11) NOT NULL,
  `supr_dtmovto` datetime DEFAULT NULL,
  `supr_dtabre` datetime DEFAULT NULL,
  `supr_usua_id` int(11) DEFAULT NULL,
  `supr_valor` decimal(10,2) DEFAULT NULL,
  `supr_usua_cancelou` int(11) DEFAULT NULL,
  `supr_dtcancela` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `turno`
--

CREATE TABLE `turno` (
  `_id` int(11) NOT NULL,
  `turno_hr_entrada` varchar(5) DEFAULT NULL,
  `turno_hr_saida` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ultimas_vendas`
--

CREATE TABLE `ultimas_vendas` (
  `_id` int(11) NOT NULL,
  `ultven_vend_id` int(11) DEFAULT NULL,
  `ultven_dtmovto` datetime DEFAULT NULL,
  `ultven_estornado` int(11) DEFAULT NULL,
  `ultven_dtestorno` datetime DEFAULT NULL,
  `ultven_detalhe` varchar(800) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ultimos_enctos`
--

CREATE TABLE `ultimos_enctos` (
  `_id` int(11) NOT NULL,
  `ultenc_usua_id` int(11) DEFAULT NULL,
  `ultenc_detalhe` varchar(800) DEFAULT NULL,
  `ultenc_dtalt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `_id` int(11) NOT NULL,
  `usua_nome` varchar(25) DEFAULT NULL,
  `usua_senha` varchar(10) DEFAULT NULL,
  `usua_perf_id` int(11) DEFAULT NULL,
  `usua_status` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda`
--

CREATE TABLE `venda` (
  `_id` int(11) NOT NULL,
  `vend_empr_id` int(11) DEFAULT NULL,
  `vend_loja_id` int(11) DEFAULT NULL,
  `vend_term_id` int(11) DEFAULT NULL,
  `vend_usua_id` int(11) DEFAULT NULL,
  `vend_cli_id` int(11) DEFAULT NULL,
  `vend_pre_venda_h` varchar(100) DEFAULT NULL,
  `vend_dtmovto` datetime DEFAULT NULL,
  `vend_dtabre` datetime DEFAULT NULL,
  `vend_dtrecebe` datetime DEFAULT NULL,
  `vend_dtcancela` datetime DEFAULT NULL,
  `vend_usua_cancelou` int(11) DEFAULT NULL,
  `vend_dtdesconto` datetime DEFAULT NULL,
  `vend_vl_desc` decimal(10,2) DEFAULT NULL,
  `vend_vl_servico` decimal(10,2) DEFAULT NULL,
  `vend_vl_troco` decimal(10,2) DEFAULT NULL,
  `vend_vl_total` decimal(10,2) DEFAULT NULL,
  `vend_nu_cupom` int(11) DEFAULT NULL,
  `vend_status` char(5) DEFAULT NULL,
  `vend_CPF_CNPJ` varchar(20) DEFAULT NULL,
  `vend_sinc` int(11) DEFAULT NULL,
  `vend_canc_sinc` int(11) DEFAULT NULL,
  `vend_email` varchar(100) DEFAULT NULL,
  `vend_cartao_fid` varchar(20) DEFAULT NULL,
  `vend_nome_cli` varchar(35) DEFAULT NULL,
  `vend_fone` varchar(25) DEFAULT NULL,
  `vend_nu_nf` int(11) DEFAULT NULL,
  `vend_serie_nf` int(11) DEFAULT NULL,
  `vend_modulo` int(11) DEFAULT NULL,
  `vend_sequencia` int(11) DEFAULT NULL,
  `vend_ticket_id` int(11) DEFAULT NULL,
  `vend_nu_pessoas` int(11) DEFAULT NULL,
  `vend_dtultcons` datetime DEFAULT NULL,
  `vend_nu_cf_sat` int(11) DEFAULT NULL,
  `vend_nu_cx_sat` int(11) DEFAULT NULL,
  `vend_nu_nfse` int(11) DEFAULT NULL,
  `vend_serie_nfse` int(11) DEFAULT NULL,
  `vend_nfse_sinc` int(11) DEFAULT NULL,
  `vend_obs` text NOT NULL DEFAULT '',
  `vend_pedido_id` text NOT NULL DEFAULT '',
  `vend_entregador_id` int(11) DEFAULT 0,
  `vend_cf_can_sat` int(11) DEFAULT NULL,
  `vend_vl_taxa` decimal(10,2) DEFAULT 0.00,
  `vend_nu_nf_descarte` int(11) DEFAULT -1,
  `vend_taxa_id` int(11) DEFAULT 0,
  `vend_sinc_cloud` int(11) DEFAULT 0,
  `vend_sinc_migrate` int(11) DEFAULT 0,
  `vend_cliente_model` text DEFAULT NULL,
  `vend_forma_pagto_model` text DEFAULT NULL,
  `vend_doc_fiscal_model` text DEFAULT NULL,
  `vend_tp_emissao` int(11) DEFAULT 0,
  `vend_app_integrado` text NOT NULL DEFAULT '',
  `vend_app_cod_referencia` text NOT NULL DEFAULT '',
  `vend_app_cupom_tipo` text DEFAULT NULL,
  `vend_app_cupom_valor` decimal(10,2) DEFAULT 0.00,
  `vend_app_entrega_tipo` text DEFAULT NULL,
  `vend_vl_cupom_valor` decimal(10,2) DEFAULT 0.00,
  `vend_terminal_nome` text NOT NULL DEFAULT '',
  `vend_dtentrega_agendada` datetime DEFAULT NULL,
  `vend_mergered_orders` text NOT NULL DEFAULT '',
  `vend_uuid` varchar(16) NOT NULL DEFAULT '',
  `vend_payment_terminal` varchar(13) NOT NULL DEFAULT '',
  `vend_discount_details` text DEFAULT '',
  `vend_doc_costumer_details` text DEFAULT '',
  `vend_localizer` text DEFAULT '',
  `vend_pickup_code` text DEFAULT '',
  `vend_indoor_tab_id` text DEFAULT '',
  `vend_indoor_tab_status_sync` int(11) DEFAULT 0,
  `vend_order_fees` text NOT NULL DEFAULT '',
  `vend_merchant_id` text NOT NULL DEFAULT '',
  `vend_merchant_name` text NOT NULL DEFAULT '',
  `vend_discount_id` int(11) DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda_composto`
--

CREATE TABLE `venda_composto` (
  `_id` int(11) NOT NULL,
  `vcomp_guid` text DEFAULT '',
  `vcomp_description` text DEFAULT '',
  `vcomp_qtdy` int(11) DEFAULT 1,
  `vcomp_modifiers` text NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda_formapagto`
--

CREATE TABLE `venda_formapagto` (
  `_id` int(11) NOT NULL,
  `vfpag_vend_id` int(11) DEFAULT NULL,
  `vfpag_form_pag_id` int(11) DEFAULT NULL,
  `vfpag_dtmovto` datetime DEFAULT NULL,
  `vfpag_valor` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda_impressao`
--

CREATE TABLE `venda_impressao` (
  `_id` int(11) NOT NULL,
  `vimp_texto` varchar(1200) DEFAULT NULL,
  `vimp_imp_id` int(11) DEFAULT NULL,
  `vimp_vend_id` int(11) DEFAULT NULL,
  `vimp_status` char(1) DEFAULT NULL,
  `vimp_dtalt` datetime DEFAULT NULL,
  `vimp_obs_venda` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda_lock`
--

CREATE TABLE `venda_lock` (
  `vlock_celula` varchar(20) NOT NULL,
  `vlock_status` varchar(5) DEFAULT NULL,
  `vlock_last_dt_sinc` varchar(20) DEFAULT NULL,
  `vlock_last_user` varchar(200) DEFAULT NULL,
  `vlock_last_terminal` varchar(12) DEFAULT NULL,
  `vlock_pre_venda_h` text NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Despejando dados para a tabela `venda_lock`
--

INSERT INTO `venda_lock` (`vlock_celula`, `vlock_status`, `vlock_last_dt_sinc`, `vlock_last_user`, `vlock_last_terminal`, `vlock_pre_venda_h`) VALUES
('4', 'TKTL', '2025/08/20 12:07:34', 'Ailton', 'EMULADORYAGO', ''),
('74', 'TKTL', '2025/10/10 13:49:16', 'SUPORTE', 'LUAN', '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda_modificador`
--

CREATE TABLE `venda_modificador` (
  `_id` int(11) NOT NULL DEFAULT 0,
  `vmod_vend_id` int(11) DEFAULT NULL,
  `vmod_mod_id` int(11) DEFAULT NULL,
  `vmod_dtmovto` datetime DEFAULT NULL,
  `vmod_vprod_id` int(11) DEFAULT NULL,
  `vmod_qtde` decimal(10,3) DEFAULT 0.000,
  `vmod_preco` decimal(10,3) DEFAULT 0.000,
  `vmod_sinc` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda_produto`
--

CREATE TABLE `venda_produto` (
  `_id` int(11) NOT NULL,
  `vprod_vend_id` int(11) DEFAULT NULL,
  `vprod_dtmovto` datetime DEFAULT NULL,
  `vprod_prod_id` int(11) DEFAULT NULL,
  `vprod_qtde` decimal(10,3) DEFAULT NULL,
  `vprod_preco` decimal(10,2) DEFAULT NULL,
  `vprod_desconto` decimal(10,2) DEFAULT NULL,
  `vprod_dtdesconto` datetime DEFAULT NULL,
  `vprod_total` decimal(10,2) DEFAULT NULL,
  `vprod_cancelado` int(11) DEFAULT NULL,
  `vprod_dtcancela` datetime DEFAULT NULL,
  `vprod_usua_cancelou` int(11) DEFAULT NULL,
  `vprod_imprimiu` int(11) DEFAULT NULL,
  `vprod_usua_id` int(11) DEFAULT NULL,
  `vprod_modificador` text DEFAULT NULL,
  `vprod_atendente_id` int(11) DEFAULT NULL,
  `vprod_ticket_orig` int(11) DEFAULT NULL,
  `vprod_seq_orig` int(11) DEFAULT NULL,
  `vprod_ticket_dest` int(11) DEFAULT NULL,
  `vprod_seq_dest` int(11) DEFAULT NULL,
  `vprod_dtlancamento` datetime DEFAULT NULL,
  `vprod_metadata` text DEFAULT NULL,
  `vprod_mod_imprimiu` int(11) DEFAULT NULL,
  `vprod_usua_desconto` int(11) DEFAULT NULL,
  `vprod_vcom_guid` text NOT NULL DEFAULT '',
  `vprod_vcom_description` text NOT NULL DEFAULT '',
  `vprod_uuid` varchar(16) NOT NULL DEFAULT '',
  `vprod_seat_number` text DEFAULT '',
  `vprod_cancel_terminal` varchar(16) NOT NULL DEFAULT '',
  `vprod_discount_terminal` varchar(16) NOT NULL DEFAULT '',
  `vprod_operations` text DEFAULT '',
  `vprod_indoor_order_ref` text DEFAULT '',
  `vprod_promo_id` int(11) DEFAULT 0,
  `vprod_discount_id` int(11) DEFAULT -1,
  `vprod_cancel_id` int(11) DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `venda_tef`
--

CREATE TABLE `venda_tef` (
  `_id` int(11) NOT NULL,
  `vtef_vend_id` int(11) NOT NULL,
  `vtef_detalhe` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `checklist_fiscal`
--
ALTER TABLE `checklist_fiscal`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`_id`),
  ADD UNIQUE KEY `idx_cli_fone1` (`cli_fone1`);

--
-- Índices de tabela `conferencia`
--
ALTER TABLE `conferencia`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `configuracao`
--
ALTER TABLE `configuracao`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `control_version`
--
ALTER TABLE `control_version`
  ADD PRIMARY KEY (`cvers_terminal_mac`);

--
-- Índices de tabela `formapagto`
--
ALTER TABLE `formapagto`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `grupoproduto`
--
ALTER TABLE `grupoproduto`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `impressora`
--
ALTER TABLE `impressora`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `modificador`
--
ALTER TABLE `modificador`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `movimento`
--
ALTER TABLE `movimento`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `produto_integracao`
--
ALTER TABLE `produto_integracao`
  ADD PRIMARY KEY (`prodi_prod_cod_externo`);

--
-- Índices de tabela `reference_order_log`
--
ALTER TABLE `reference_order_log`
  ADD PRIMARY KEY (`reford_number`);

--
-- Índices de tabela `sangria`
--
ALTER TABLE `sangria`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `suprimento`
--
ALTER TABLE `suprimento`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `turno`
--
ALTER TABLE `turno`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `ultimas_vendas`
--
ALTER TABLE `ultimas_vendas`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `ultimos_enctos`
--
ALTER TABLE `ultimos_enctos`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `venda`
--
ALTER TABLE `venda`
  ADD PRIMARY KEY (`_id`),
  ADD UNIQUE KEY `idx_id_status_ticket` (`_id`,`vend_status`,`vend_ticket_id`);

--
-- Índices de tabela `venda_composto`
--
ALTER TABLE `venda_composto`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `venda_formapagto`
--
ALTER TABLE `venda_formapagto`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `venda_impressao`
--
ALTER TABLE `venda_impressao`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `venda_lock`
--
ALTER TABLE `venda_lock`
  ADD PRIMARY KEY (`vlock_celula`);

--
-- Índices de tabela `venda_modificador`
--
ALTER TABLE `venda_modificador`
  ADD PRIMARY KEY (`_id`);

--
-- Índices de tabela `venda_produto`
--
ALTER TABLE `venda_produto`
  ADD PRIMARY KEY (`_id`),
  ADD UNIQUE KEY `idx_id_vendid` (`_id`,`vprod_vend_id`);

--
-- Índices de tabela `venda_tef`
--
ALTER TABLE `venda_tef`
  ADD PRIMARY KEY (`_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `checklist_fiscal`
--
ALTER TABLE `checklist_fiscal`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `conferencia`
--
ALTER TABLE `conferencia`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `configuracao`
--
ALTER TABLE `configuracao`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `formapagto`
--
ALTER TABLE `formapagto`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `grupoproduto`
--
ALTER TABLE `grupoproduto`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `impressora`
--
ALTER TABLE `impressora`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `movimento`
--
ALTER TABLE `movimento`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `perfil`
--
ALTER TABLE `perfil`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `sangria`
--
ALTER TABLE `sangria`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `suprimento`
--
ALTER TABLE `suprimento`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `turno`
--
ALTER TABLE `turno`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ultimas_vendas`
--
ALTER TABLE `ultimas_vendas`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ultimos_enctos`
--
ALTER TABLE `ultimos_enctos`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `venda`
--
ALTER TABLE `venda`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5413;

--
-- AUTO_INCREMENT de tabela `venda_composto`
--
ALTER TABLE `venda_composto`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `venda_formapagto`
--
ALTER TABLE `venda_formapagto`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `venda_impressao`
--
ALTER TABLE `venda_impressao`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `venda_produto`
--
ALTER TABLE `venda_produto`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=331732;

--
-- AUTO_INCREMENT de tabela `venda_tef`
--
ALTER TABLE `venda_tef`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
