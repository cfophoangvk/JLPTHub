<%@ tag description="Flip Card for Flashcard Learning" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="id" required="true" type="java.lang.String" description="Unique ID for the card" %>
<%@ attribute name="term" required="true" type="java.lang.String" description="Front side content (term)" %>
<%@ attribute name="definition" required="true" type="java.lang.String" description="Back side content (definition)" %>
<%@ attribute name="termImage" required="false" type="java.lang.String" description="Optional image URL for term" %>
<%@ attribute name="definitionImage" required="false" type="java.lang.String" description="Optional image URL for definition" %>
<%@ attribute name="className" required="false" type="java.lang.String" description="Additional CSS classes" %>

<div id="${id}" class="flip-card cursor-pointer ${className}" onclick="flipCard('${id}')">
    <div class="flip-card-inner">
        <!-- Front Side (Term) -->
        <div class="flip-card-front bg-white rounded-2xl shadow-lg border border-gray-200 p-8 flex flex-col items-center justify-center">
            <c:if test="${not empty termImage}">
                <img src="${termImage}" alt="${term}" class="max-h-40 object-contain mb-4 rounded-lg"/>
            </c:if>
            <p class="text-3xl font-bold text-gray-900 text-center">${term}</p>
            <p class="text-sm text-gray-400 mt-4">
                <i class="fa-solid fa-hand-pointer mr-1"></i> Nhấn để lật thẻ
            </p>
        </div>
        
        <!-- Back Side (Definition) -->
        <div class="flip-card-back bg-gradient-to-br from-rose-400 to-rose-600 rounded-2xl shadow-lg p-8 flex flex-col items-center justify-center">
            <c:if test="${not empty definitionImage}">
                <img src="${definitionImage}" alt="${definition}" class="max-h-40 object-contain mb-4 rounded-lg"/>
            </c:if>
            <p class="text-2xl font-semibold text-white text-center">${definition}</p>
            <p class="text-sm text-rose-100 mt-4">
                <i class="fa-solid fa-hand-pointer mr-1"></i> Nhấn để lật lại
            </p>
        </div>
    </div>
</div>
