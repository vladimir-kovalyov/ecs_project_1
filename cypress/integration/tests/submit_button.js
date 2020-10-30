/// <reference types="cypress" />

context('Actions', () => {
  beforeEach(() => {
    cy.visit('http://localhost:8080');
  });

  it('.type() - type into a DOM element', () => {
    // https://on.cypress.io/type
    cy.get('#form-title')
      .type('Blog Title').should('have.value', 'Blog Title')

      // .type() with special character sequences
      .type('{leftarrow}{rightarrow}{uparrow}{downarrow}')
      .type('{del}{selectall}{backspace}')

      // .type() with key modifiers
      .type('{alt}{option}') //these are equivalent
      .type('{ctrl}{control}') //these are equivalent
      .type('{meta}{command}{cmd}') //these are equivalent
      .type('{shift}')

      // Delay each keypress by 0.1 sec
      .type('Blog Title Slow', { delay: 100 })
      .should('have.value', 'Blog Title Slow');
  });

  it('.type() - type into a DOM element', () => {
    // https://on.cypress.io/type
    cy.get('#form-content')
      .type('Lorem ipsum').should('have.value', 'Lorem ipsum')

      // .type() with special character sequences
      .type('{leftarrow}{rightarrow}{uparrow}{downarrow}')
      .type('{del}{selectall}{backspace}')

      // .type() with key modifiers
      .type('{alt}{option}') //these are equivalent
      .type('{ctrl}{control}') //these are equivalent
      .type('{meta}{command}{cmd}') //these are equivalent
      .type('{shift}')

      // Delay each keypress by 0.1 sec
      .type('Lorem ipsum slow', { delay: 100 })
      .should('have.value', 'Lorem ipsum slow');
  });

  it('.type() - type into a DOM element', () => {
    // https://on.cypress.io/type
    cy.get('#form-author')
      .type('ECS Author').should('have.value', 'ECS Author')

      // .type() with special character sequences
      .type('{leftarrow}{rightarrow}{uparrow}{downarrow}')
      .type('{del}{selectall}{backspace}')

      // .type() with key modifiers
      .type('{alt}{option}') //these are equivalent
      .type('{ctrl}{control}') //these are equivalent
      .type('{meta}{command}{cmd}') //these are equivalent
      .type('{shift}')

      // Delay each keypress by 0.1 sec
      .type('ECS Author slow', { delay: 100 })
      .should('have.value', 'ECS Author slow');
  });

  it('.clear() - clears an input or textarea element', () => {
    // https://on.cypress.io/clear
    cy.get('#form-title').type('Clear this text')
      .should('have.value', 'Clear this text')
      .clear()
      .should('have.value', '');
  });

  it('.submit() - submit a form', () => {
    // https://on.cypress.io/submit
    cy.get('#form').submit();
    cy.url().should('include', '/blogs');
  });
});
