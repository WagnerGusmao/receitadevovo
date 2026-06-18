"use client";

import { useEffect, useRef, forwardRef } from "react";

interface ShippingLabelProps {
  order: any;
  freightValue?: number;
  trackingCode?: string;
  weightKg?: number;
  boxDimensions?: string;
}

const ShippingLabel = forwardRef<HTMLDivElement, ShippingLabelProps>(
  ({ order, freightValue, trackingCode, weightKg, boxDimensions }, ref) => {
    const address = order?.shipping_address || "";

    return (
      <div
        ref={ref}
        className="shipping-label"
        style={{
          width: "10cm",
          minHeight: "15cm",
          border: "2px solid #1a1a1a",
          padding: "0.5cm",
          fontFamily: "Arial, sans-serif",
          fontSize: "9pt",
          backgroundColor: "#ffffff",
          color: "#000000",
          position: "relative",
          boxSizing: "border-box",
        }}
      >
        {/* Header */}
        <div
          style={{
            borderBottom: "2px solid #1a1a1a",
            paddingBottom: "0.3cm",
            marginBottom: "0.3cm",
            display: "flex",
            justifyContent: "space-between",
            alignItems: "flex-start",
          }}
        >
          <div>
            <div style={{ fontWeight: "bold", fontSize: "13pt", color: "#5a3e1b" }}>
              🌿 Receita de Vovó
            </div>
            <div style={{ fontSize: "7pt", color: "#555" }}>
              Produtos Artesanais Naturais
            </div>
          </div>
          <div style={{ textAlign: "right" }}>
            <div style={{ fontSize: "7pt", color: "#555" }}>Pedido</div>
            <div style={{ fontWeight: "bold", fontSize: "11pt" }}>
              {order?.order_number}
            </div>
            {order?.shipping_method && (
              <div style={{ fontSize: "7.5pt", fontWeight: "bold", color: "#333", marginTop: "0.1cm", textTransform: "uppercase" }}>
                🚚 {order.shipping_method}
              </div>
            )}
          </div>
        </div>

        {/* Remetente */}
        <div
          style={{
            background: "#f5f5f5",
            padding: "0.25cm",
            borderRadius: "3px",
            marginBottom: "0.3cm",
            border: "1px solid #ddd",
          }}
        >
          <div style={{ fontWeight: "bold", fontSize: "7pt", textTransform: "uppercase", color: "#888", marginBottom: "0.1cm" }}>
            Remetente
          </div>
          <div style={{ fontWeight: "bold" }}>Receita de Vovó</div>
          <div style={{ fontSize: "8pt" }}>receitadevovo@receitadevovo.com.br</div>
        </div>

        {/* Destinatário */}
        <div
          style={{
            border: "2px solid #1a1a1a",
            padding: "0.3cm",
            borderRadius: "3px",
            marginBottom: "0.3cm",
          }}
        >
          <div
            style={{
              fontWeight: "bold",
              fontSize: "7pt",
              textTransform: "uppercase",
              color: "#888",
              marginBottom: "0.15cm",
            }}
          >
            ▶ Destinatário
          </div>
          <div style={{ fontWeight: "bold", fontSize: "11pt" }}>
            {order?.user?.name || order?.customer_name || "—"}
          </div>
          {order?.user?.email && (
            <div style={{ fontSize: "8pt", color: "#555" }}>{order.user.email}</div>
          )}
          {order?.customer_phone && (
            <div style={{ fontSize: "8pt" }}>Tel: {order.customer_phone}</div>
          )}
          <div
            style={{
              marginTop: "0.2cm",
              fontSize: "9pt",
              lineHeight: "1.4",
              borderTop: "1px dashed #ccc",
              paddingTop: "0.15cm",
            }}
          >
            {address}
          </div>
        </div>

        {/* Itens */}
        <div style={{ marginBottom: "0.3cm" }}>
          <div
            style={{
              fontWeight: "bold",
              fontSize: "7pt",
              textTransform: "uppercase",
              color: "#888",
              marginBottom: "0.1cm",
            }}
          >
            Conteúdo do Pacote
          </div>
          {order?.items?.map((item: any, i: number) => (
            <div
              key={i}
              style={{
                display: "flex",
                justifyContent: "space-between",
                fontSize: "8pt",
                borderBottom: "1px dotted #ddd",
                paddingBottom: "0.1cm",
                marginBottom: "0.1cm",
              }}
            >
              <span>
                {item.quantity}x {item.itemable?.name}
              </span>
              <span>R$ {(item.quantity * item.price).toFixed(2)}</span>
            </div>
          ))}
        </div>

        {/* Dados de envio */}
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "1fr 1fr",
            gap: "0.15cm",
            marginBottom: "0.3cm",
            fontSize: "8pt",
          }}
        >
          {weightKg && (
            <div style={{ background: "#f5f5f5", padding: "0.15cm", borderRadius: "3px" }}>
              <div style={{ fontSize: "6pt", color: "#888", textTransform: "uppercase" }}>Peso</div>
              <div style={{ fontWeight: "bold" }}>{weightKg} kg</div>
            </div>
          )}
          {boxDimensions && (
            <div style={{ background: "#f5f5f5", padding: "0.15cm", borderRadius: "3px" }}>
              <div style={{ fontSize: "6pt", color: "#888", textTransform: "uppercase" }}>Dimensões</div>
              <div style={{ fontWeight: "bold" }}>{boxDimensions} cm</div>
            </div>
          )}
          {freightValue !== undefined && freightValue > 0 && (
            <div style={{ background: "#f5f5f5", padding: "0.15cm", borderRadius: "3px" }}>
              <div style={{ fontSize: "6pt", color: "#888", textTransform: "uppercase" }}>Frete</div>
              <div style={{ fontWeight: "bold" }}>R$ {freightValue.toFixed(2)}</div>
            </div>
          )}
          <div style={{ background: "#f5f5f5", padding: "0.15cm", borderRadius: "3px" }}>
            <div style={{ fontSize: "6pt", color: "#888", textTransform: "uppercase" }}>Total Pedido</div>
            <div style={{ fontWeight: "bold" }}>R$ {parseFloat(order?.total || 0).toFixed(2)}</div>
          </div>
        </div>

        {/* Código de rastreio */}
        <div
          style={{
            border: "2px solid #1a1a1a",
            padding: "0.25cm",
            borderRadius: "3px",
            textAlign: "center",
            marginBottom: "0.3cm",
          }}
        >
          <div style={{ fontSize: "7pt", color: "#888", textTransform: "uppercase", marginBottom: "0.1cm" }}>
            Código de Rastreio
          </div>
          {trackingCode ? (
            <>
              <div style={{ fontWeight: "bold", fontSize: "12pt", letterSpacing: "0.1cm" }}>
                {trackingCode}
              </div>
              {/* Barcode visual simulado */}
              <div
                style={{
                  display: "flex",
                  justifyContent: "center",
                  gap: "1px",
                  marginTop: "0.15cm",
                  height: "0.8cm",
                  alignItems: "stretch",
                }}
              >
                {Array.from(trackingCode.replace(/[^A-Z0-9]/g, "")).map((char, i) => (
                  <div
                    key={i}
                    style={{
                      width: `${(char.charCodeAt(0) % 3) + 1}px`,
                      background: "#000",
                      display: "inline-block",
                    }}
                  />
                ))}
              </div>
            </>
          ) : (
            <div style={{ fontStyle: "italic", color: "#aaa", fontSize: "8pt" }}>
              Sem rastreio informado
            </div>
          )}
        </div>

        {/* Footer */}
        <div
          style={{
            borderTop: "1px solid #ddd",
            paddingTop: "0.2cm",
            display: "flex",
            justifyContent: "space-between",
            fontSize: "7pt",
            color: "#888",
          }}
        >
          <span>receitadevovo.com.br</span>
          <span>Emitido em {new Date().toLocaleDateString("pt-BR")}</span>
        </div>
      </div>
    );
  }
);

ShippingLabel.displayName = "ShippingLabel";

export default ShippingLabel;
